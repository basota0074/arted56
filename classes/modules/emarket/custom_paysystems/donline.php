<?php

	use UmiCms\Service;

	require_once dirname(__FILE__) . '/base.php';

	class custom_paysystem_donline extends custom_paysystem_base {

		public function __construct() {
			$arGuidesList = umiObjectTypesCollection::getInstance()->getGuidesList();
			$iTypeId = false;
			foreach ($arGuidesList as $guideId => $guideName) {
				if (strcmp($guideName, 'Способы оплаты заказа сайта') == 0) {
					$iTypeId = $guideId;
					break;
				}
			}

			if ($iTypeId) {
				$sel = new selector('objects');
				$sel->types('object-type')->id($iTypeId);
				$sel->where('paysystem_id')->equals('donline');
				$this->umiObject = $sel->first();
			}
		}

		/*
		 * d.online URL
		 */
		public function getPaymentUrl($orderId) {
			$order = order::get($orderId);
			if (!$order) {
				return '';
			}

			$currency = mb_strtoupper(mainConfiguration::getInstance()->get('system', 'default-currency'));
			if ($currency == 'RUR') {
				$currency = 'RUB';
			}

			$arParams = [];
			$arParams['project'] = $this->getAuthorInfoField('donline_project_id');
			$arParams['source'] = $arParams['project'];
			$arParams['amount'] = $order->getActualPrice();
			$arParams['nickname'] = $orderId;
			$arParams['order_id'] = $orderId;
			$arParams['comment'] = "Payment for order {$orderId}";
			$arParams['paymentCurrency'] = $currency;

			return 'http://paymentgateway.ru/?' . http_build_query($arParams);
		}

		/** Callback */
		public function callback() {
			$amount = getRequest('amount');
			$userId = (int) getRequest('userid');
			$paymentId = (int) getRequest('paymentid');
			$orderId = (int) getRequest('orderid');
			$key = getRequest('key');
			$userKey = $this->getAuthorInfoField('donline_key');

			$success = false;
			$errorCode = 'unknown';
			$successCode = 'success';

			if (!$orderId && $userId) {
				$key = getRequest('key');
				$checkSign = md5('0' . $userId . '0' . $userKey);
				if ($checkSign == $key) {
					$success = true;
				} else {
					$errorCode = 'cheksign';
				}
			} elseif ($orderId && $paymentId) {
				$order = order::get($orderId);
				if ($order instanceof order) {
					$checkSign = md5($amount . $userId . $paymentId . $userKey);
					if ($checkSign == $key && ($order->getActualPrice() - $amount) < 0.001) {
						$order->setOrderStatus('accepted');
						$order->setPaymentStatus('accepted');
						$order->setPaymentDocumentNumber($paymentId);
						$success = true;
						if (($amount - $order->getActualPrice()) >= 0.01) {
							$successCode = 'success_payedmore';
						}
					} else {
						if ($checkSign != $key) {
							$errorCode = 'cheksign';
						} elseif (($order->getActualPrice() - $amount) >= 0.001) {
							$errorCode = 'wrongamount';
						}
					}
				} else {
					$errorCode = 'noorder';
				}
			}

			$buffer = Service::Response()
				->getCurrentBuffer();
			$buffer->clear();
			$buffer->contentType('text/xml');

			if ($success) {
				$buffer->push('<?xml version="1.0" encoding="UTF-8"?>
							<result>
								<id>' . $orderId . '</id>
								<code>YES</code>
								<comment>' . $successCode . $this->describeCommentCode($successCode) . '</comment>
							</result>');
			} else {
				$buffer->push('<?xml version="1.0" encoding="UTF-8"?>
							<result>
								<id>' . $orderId . '</id>
								<code>NO</code>
								<comment>' . $errorCode . $this->describeCommentCode($errorCode) . '</comment>
							</result>');
			}
			$buffer->end();
		}

		public function enabled() {
			$projectId = trim($this->getAuthorInfoField('donline_project_id'));
			$key = trim($this->getAuthorInfoField('donline_key'));

			return ($projectId != '' && $key != '');
		}

		/**
		 * Словесное описание кода сообщения с ведущим пробелом (или пустая строка)
		 * @param string $commentCode Код сообщения
		 *
		 * @return string
		 */
		protected function describeCommentCode($commentCode) {
			$message = '';
			switch ($commentCode) {
				case 'cheksign':
					$message = ' Неверное секретное слово';
					break;
				case 'wrongamount':
					$message = ' Сумма платежа меньше суммы заказа';
					break;
				case 'noorder':
					$message = ' В системе не найден заказ с указанным идентификатором';
					break;
				case 'success_payedmore':
					$message = ' Сумма платежа больше суммы заказа';
					break;
			}
			return $message;
		}
	}
