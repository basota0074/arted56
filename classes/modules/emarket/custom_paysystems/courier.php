<?php

	use UmiCms\Service;

	require_once dirname(__FILE__) . '/base.php';

	class custom_paysystem_courier extends custom_paysystem_base {

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
				$sel->where('paysystem_id')->equals('courier');
				$this->umiObject = $sel->first();
			}
		}

		public function getPaymentUrl($orderId) {
			return '/emarket/purchase/result/successful/';
		}

		public function callback() {
			$buffer = Service::Response()
				->getCurrentBuffer();
			$buffer->clear();
			$buffer->contentType('text/html');
			$buffer->push('no callback for courier payment');
			$buffer->end();
			return;
		}

		public function enabled() {
			return true;
		}
	}
