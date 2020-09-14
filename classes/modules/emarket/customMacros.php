<?php

	use UmiCms\Service;

	/** Класс пользовательских методов для всех режимов */
	class EmarketSolutionCustomMacros {

		/** @var emarket $module */
		public $module;

		/**
		 * Отправка письма при смене статуса заказа
		 * @param order $oOrder
		 * @param int $oldStatus
		 */
		public function mailingOnChangeStatus($oOrder, $oldStatus) {
			$oldStatusId = $oldStatus;
			$isNewOrder = empty($oldStatusId);

			$orderId = $oOrder->id;
			$orderNumber = $oOrder->number;
			$codeNameOrderStatus = order::getCodeByStatus($oOrder->getOrderStatus());

			$regedit = Service::Registry();
			/**
			 * Логика для обратной совместимости.
			 * При редактировании из /admin значения в реестр сохраняются с id домена.
			 * При работе из контроллера - такой логики на момент написания этого кода нет. Поэтому делаем доп. проверки.
			 */
			$domain = $oOrder->getDomain();
			if (!$domain) {
				$domain = Service::DomainCollection()->getDefaultDomain();
			}
			$domain_id = $domain->getId();
			$fromEmail = mb_strtolower($regedit->get('//modules/emarket/from-email'));
			$fromName = $regedit->get('//modules/emarket/from-name');
			$email = $regedit->get('//modules/emarket/manager-email');

			$fromEmailDomain = mb_strtolower($regedit->get("//modules/emarket/from-email/{$domain_id}"));
			if (!empty($fromEmailDomain)) {
				$fromEmail = $fromEmailDomain;
			}
			$fromNameDomain = $regedit->get("//modules/emarket/from-name/{$domain_id}");
			if (!empty($fromNameDomain)) {
				$fromName = $fromNameDomain;
			}
			$emailDomain = $regedit->get("//modules/emarket/manager-email/{$domain_id}");
			if (!empty($emailDomain)) {
				$email = $emailDomain;
			}

			$langs = cmsController::getInstance()->getLangConstantList();

			$guidesList = umiObjectTypesCollection::getInstance()->getGuidesList(true);

			// Проверяем надо ли отправлять письмо пользователю сделавшему заказ
			$isSendForCustomer = (
				($guideId = array_search('Шаблоны писем', $guidesList)) &&
				($items = umiObjectsCollection::getInstance()->getGuidedItems($guideId)) &&
				($arTemplatesId = array_search($codeNameOrderStatus, $items)) &&
				$arTemplatesId &&
				($item = umiObjectsCollection::getInstance()->getObject($arTemplatesId)) &&
				$item->getValue('is_used')
			);

			if ($isSendForCustomer) {
				$domainName = false;

				if (!$domainName) {
					$oDomain = Service::DomainCollection()->getDomain($oOrder->domain_id);
					if ($oDomain) {
						$domainName = $oDomain->getHost();
					}
				}

				$customerName = trim(implode(' ', [$oOrder->cust_lname, $oOrder->cust_fname, $oOrder->cust_father_name]));
				$uri = "udata://emarket/order/{$orderId}/?transform=sys-tpls/mail-order-info.xsl";
				$orderInfo = file_get_contents($uri);

				$arMailingTags = [
					'{fio}' => $customerName,
					'{orderNumber}' => $orderNumber,
					'{orderInfo}' => $orderInfo,
					'{domain}' => $domainName,
					'{n}' => "\n",
					'{r}' => "\r",
				];

				$theme = str_replace(array_keys($arMailingTags), $arMailingTags, $item->getValue('theme'));
				$template = str_replace(array_keys($arMailingTags), $arMailingTags, html_entity_decode($item->getValue('template')));

				$customerMessage = new umiMail();
				$customerMessage->addRecipient(mb_strtolower($oOrder->cust_email));
				$customerMessage->setFrom($fromEmail, $fromName);
				$customerMessage->setSubject($theme);

				$customerMessage->setContent($template);
				$customerMessage->commit();
				$customerMessage->send();
			}

			// Извещаем менеджера сайта о новом заказе
			if ($codeNameOrderStatus == 'waiting' && $isNewOrder) {
				$uri = "udata://emarket/order/{$orderId}/?transform=sys-tpls/mail.xsl";
				$mailContent = file_get_contents($uri);

				$email = preg_replace('/[\s;,]+/', ',', $email);
				$arEmails = explode(',', $email);
				$letter = new umiMail();
				foreach ($arEmails as $sEmail) {
					$letter->addRecipient(mb_strtolower($sEmail));
				}
				$letter->setFrom($fromEmail, $fromName);
				$letter->setSubject($langs['notification-neworder-subject'] . " (№{$orderNumber})");
				$letter->setContent($mailContent);
				$letter->commit();
				$letter->send();
			}
		}

		/**
		 * Срабатывает при изменении
		 * @param iUmiEventPoint $event
		 */
		public function onStatusChangedCustom(iUmiEventPoint $event) {
			if ($event->getMode() == 'after' &&
				$event->getParam('old-status-id') != $event->getParam('new-status-id')) {
				$orderRef = $event->getRef('order');
				$this->mailingOnChangeStatus($orderRef, $event->getParam('old-status-id'));
			}
		}

		/**
		 * Срабатывает при редактировании поля из таблицы
		 * @param iUmiEventPoint $event
		 */
		public function onStatusChangedToReady(iUmiEventPoint $event) {
			if ($event->getMode() == 'after' &&
				$event->getParam('oldValue') != $event->getParam('newValue')) {
				$eventEntity = $event->getRef('entity');
				$oOrder = order::get($eventEntity->id);
				if ($oOrder instanceof order) {
					$this->mailingOnChangeStatus($oOrder, $event->getParam('oldValue'));
				}
			}
		}

		/**
		 * Срабатывает при редактировании из страницы объекта
		 * @param iUmiEventPoint $event
		 */
		public function onModifyStatusObject(iUmiEventPoint $event) {
			static $oldStatusCache = [];
			/** @var iUmiObject $object */
			$object = $event->getRef('object');
			$typeId = umiObjectTypesCollection::getInstance()->getBaseType('emarket', 'order');
			if ($object->getTypeId() != $typeId) {
				return;
			}
			if ($event->getMode() == 'before') {
				$data = getRequest('data');
				$id = $object->getId();
				$newOrderStatus = getArrayKey($data[$id], 'status_id');
				if ($newOrderStatus != $object->getValue('status_id')) {
					$oldStatusCache[$object->getId()] = $object->getValue('status_id');
				}
			} elseif ($event->getMode() == 'after' && isset($oldStatusCache[$object->getId()])) {
				$oOrder = order::get($object->getId());
				$this->mailingOnChangeStatus($oOrder, $oldStatusCache[$object->getId()]);
			}
		}

		/** Create order from basket & set fields to customer if he is unregistered */
		public function order_create() {
			/** @var order $order */
			$order = $this->module->getBasketOrder();
			if ($order->isEmpty()) {
				$this->module->errorNewMessage(getLabel('error-market-empty-basket'));
			}

			//Fill order & customer fields
			if (isset($_REQUEST['data']) && isset($_REQUEST['data']['new']) && is_array($_REQUEST['data']['new'])) {
				$_REQUEST['data'][$order->getId()] = $_REQUEST['data']['new'];
				/** @var DataForms $data */
				$data = cmsController::getInstance()->getModule('data');
				$data->saveEditedObjectWithIgnorePermissions($order->getId(), false, true);

				if (!Service::Auth()->isAuthorized()) {
					try {
						$oCustomer = umiObjectsCollection::getInstance()->getObject($order->getCustomerId());
						foreach ($_REQUEST['data']['new'] as $field => $value) {
							$oCustomer->setValue(str_replace('cust_', '', $field), $value);
						}
						$oCustomer->commit();
					} catch (Exception $e) {
						$this->module->errorNewMessage($e->getMessage());
					}
				}
			}

			$paysystemsEnabled = $this->paysystemEnabled();
			//If paysystems disabled - set default payment type - cash
			if (!$paysystemsEnabled) {
				$cash = $this->getCustomPaysystem('courier');
				$order->setValue('custom_order_payment_type', $cash->getId());
			}

			// Если передана информация о варианте доставки, сохраняем её в заказе
			if (isset($_REQUEST['delivery_id']) && is_numeric($_REQUEST['delivery_id']) && $_REQUEST['delivery_id'] > 0) {

				$sel = new selector('objects');
				$sel->types('object-type')->name('emarket', 'delivery');
				$sel->where('id')->equals($_REQUEST['delivery_id']);
				$sel->limit(0, 1);
				$sel->option('return')->value(['id', 'name', 'sum']);
				$deliveryOptionData = isset($sel->result()[0]) ? $sel->result()[0] : null;
				if (!empty($deliveryOptionData) &&
					isset($deliveryOptionData['id'], $deliveryOptionData['name'], $deliveryOptionData['sum'])) {
					$order->setValue('delivery_id', $deliveryOptionData['id']);
					$order->setValue('delivery_name', $deliveryOptionData['name']);
					$order->setValue('delivery_price', $deliveryOptionData['sum']);
				}
			}

			// Перед комитом пересчитываем стоимость заказа, если указана доставка, то стоимость изменится
			$order->refresh();

			// Сохраняем изменения
			$order->commit();

			//Form order
			$order->order();

			//return current setup
			$arResult = [
				'order_id' => $order->getId(),
				'paysystem' => $paysystemsEnabled,
			];

			$module = $this->module;
			return $module::parseTemplate([], $arResult);
		}

		/**
		 * Возвращает список вариантов доставки
		 * @return mixed|string
		 */
		public function getDeliveryOptions() {
			// Получаем доступные варианты доставки
			try {
				$deliveryOptions = new selector('objects');
				$deliveryOptions->types('object-type')->guid('emarket-delivery-umiru-custom');
				$deliveryOptions->where('enabled')->equals(1);
				$deliveryOptions->order('sort_order')->asc();
				$deliveryOptions->option('return')->value(['id', 'name', 'sum']);
			} catch (selectorException $e) {
				return [];
			}

			$arDeliveryOption = ['nodes:option' => []];
			foreach ($deliveryOptions->result as $name => $deliveryOption) {
				$arDeliveryOption['nodes:option'][] = [
					'attribute:id' => $deliveryOption['id'],
					'attribute:name' => $deliveryOption['name'],
					'attribute:sum' => $deliveryOption['sum'],
				];
			}

			$module = $this->module;
			return $module::parseTemplate([], $arDeliveryOption);
		}

		/**
		 * Getting paysystem state
		 * @return boolean
		 */
		public function paysystemEnabled() {
			$iTypeId = false;
			$oHierarchyType = umiHierarchyTypesCollection::getInstance()->getTypeByName('content', '');
			$arTypes = umiObjectTypesCollection::getInstance()->getTypesByHierarchyTypeId($oHierarchyType->getId());
			foreach ($arTypes as $typeId => $sTypeName) {
				if ($sTypeName == 'Авторская информация') {
					$iTypeId = $typeId;
					break;
				}
			}
			if (!$iTypeId) {
				return false;
			}

			$sel = new selector('objects');
			$sel->types('object-type')->id($iTypeId);
			$sel->limit(0, 1);
			$object = $sel->first();
			if (!$object) {
				return false;
			}

			return (int) $object->paysystems_enabled;
		}

		/** Payment systems chooser */
		public function order_paysystem() {

			if (!$this->paysystemEnabled()) {
				return;
			}

			$orderId = getRequest('param0');
			$mode = getRequest('param1');
			$type = getRequest('param2');

			$order = umiObjectsCollection::getInstance()->getObject($orderId);
			$this->detectPaysystemErrors($order);

			if ($mode == 'do') {
				//get payment type
				if (!$type) {
					$this->module->errorNewMessage(getLabel('error-market-custom-no-such-paysystem'));
				}

				$oPaysystem = $this->getCustomPaysystem($type);
				//save payment type into order
				$selectedPaysystem = $order->getValue('custom_order_payment_type');
				if (!$selectedPaysystem) {
					$order->setValue('custom_order_payment_type', $oPaysystem->getId());
					$order->commit();
				}
				//redirect to payment system
				$this->module->redirect($oPaysystem->getPaymentUrl($orderId));
				return;
			}

			//get list of available payment systems
			$arResult = ['nodes:system' => []];
			$arPaySystems = $this->getAllCustomPaysystems();
			foreach ($arPaySystems as $oPaysystem) {
				if ($oPaysystem->enabled()) {
					$arResult['nodes:system'][] = [
						'attribute:caption' => $oPaysystem->getName(),
						'attribute:id' => $oPaysystem->getId(),
						'node:value' => "/emarket/order_paysystem/{$orderId}/do/{$oPaysystem->getIdentificator()}/",
					];
				}
			}

			return def_module::parseTemplate([], $arResult);
		}

		/**
		 * Check paysystem setting availability
		 * @param iUmiObject $order
		 */
		public function detectPaysystemErrors($order) {
			if (!$order) {
				$this->module->errorNewMessage(getLabel('error-market-custom-no-such-order'));
			}
			$paySystem = $order->getValue('custom_order_payment_type');
			if (!empty($paySystem)) {
				$this->module->errorNewMessage(getLabel('error-market-custom-payment-already-set'));
			}
			$customer = customer::get();
			$customerId = $customer->getId();
			$orderCustomer = $order->getValue('customer_id');
			if ($customerId != $orderCustomer) {
				$this->module->errorNewMessage(getLabel('error-market-custom-wrong-customer'));
			}
		}

		/**
		 * Get custom payment system object by its name
		 * @param string $type
		 * @return custom_paysystem_base
		 */
		public function getCustomPaysystem($type) {
			if (!file_exists(dirname(__FILE__) . "/custom_paysystems/{$type}.php")) {
				$this->module->errorNewMessage(getLabel('error-market-custom-no-such-paysystem'));
			}

			require_once dirname(__FILE__) . "/custom_paysystems/{$type}.php";

			$className = "custom_paysystem_{$type}";
			if (!class_exists($className)) {
				$this->module->errorNewMessage(getLabel('error-market-custom-no-such-paysystem'));
			}

			return new $className();
		}

		/**
		 * Получить массив всех объектов кастомных платёжных систем
		 * @return array
		 */
		public function getAllCustomPaysystems() {
			$arGuidesList = umiObjectTypesCollection::getInstance()->getGuidesList();
			$iTypeId = false;
			foreach ($arGuidesList as $guideId => $guideName) {
				if (strcmp($guideName, 'Способы оплаты заказа сайта') == 0) {
					$iTypeId = $guideId;
					break;
				}
			}
			if (!$iTypeId) {
				$this->module->errorNewMessage(getLabel('error-market-custom-no-paysystems'));
			}

			$paySystemObjects = umiObjectsCollection::getInstance()->getGuidedItems($iTypeId);
			$arResult = [];

			foreach ($paySystemObjects as $paysystemId => $paysystemCaption) {
				$object = umiObjectsCollection::getInstance()->getObject($paysystemId);
				$oPaysystem = $this->getCustomPaysystem($object->getValue('paysystem_id'));
				$arResult[] = $oPaysystem;
			}

			return $arResult;
		}

		public function order_paysystem_callback() {
			$orderId = (int) getRequest('param0');
			if (!$orderId) {
				$orderId = (int) getRequest('order-id');
			}        // Chronopay
			if (!$orderId) {
				$orderId = (int) getRequest('shp_orderId');
			}    // Robox
			if (!$orderId) {
				$orderId = (int) getRequest('orderId');
			}        // RBK
			if (!$orderId) {
				$orderId = (int) getRequest('MNT_TRANSACTION_ID');
			}    // PayAnyWay
			if (!$orderId) {
				$orderId = (int) getRequest('orderid');
			}    // Dengi Online

			$buffer = Service::Response()
				->getCurrentBuffer();

			if (!$orderId) {
				$buffer->clear();
				$buffer->contentType('text/html');
				$buffer->push('No order detected in callback');
				$buffer->end();
				return;
			}

			try {
				$order = order::get($orderId);
			} catch (Exception $e) {
				$buffer->clear();
				$buffer->contentType('text/html');
				$buffer->push($e->getMessage());
				$buffer->end();
				return;
			}

			if (!$order instanceof order) {
				$buffer->clear();
				$buffer->contentType('text/html');
				$buffer->push('No order detected in callback');
				$buffer->end();
				return;
			}

			$paysystemId = $order->getValue('custom_order_payment_type');
			$objPaysystem = umiObjectsCollection::getInstance()->getObject($paysystemId);
			if (!$objPaysystem) {
				$buffer->clear();
				$buffer->contentType('text/html');
				$buffer->push('No such paysystem');
				$buffer->end();
				return;
			}
			$paysystemType = $objPaysystem->getValue('paysystem_id');
			$paysystem = $this->getCustomPaysystem($paysystemType);
			return $paysystem->callback();
		}
	}
