<?php

	abstract class custom_paysystem_base {

		/**
		 * Object of paysystem in UMI.CMS
		 * @var umiObject
		 */
		protected $umiObject;

		/**
		 * Object of author info page
		 * @var umiObject
		 */
		protected $authorInfoPage;

		/**
		 * Get umi object Id
		 * @return int
		 */
		public function getId() {
			if ($this->umiObject instanceof iUmiObject) {
				return $this->umiObject->getId();
			}
			return null;
		}

		/**
		 * Get readable caption of payment system
		 * @return string
		 */
		public function getName() {
			if ($this->umiObject instanceof iUmiObject) {
				return $this->umiObject->getName();
			}
			return null;
		}

		/**
		 * Get paysystem identifier
		 * @return string
		 */
		public function getIdentificator() {
			if ($this->umiObject instanceof iUmiObject) {
				return $this->umiObject->getValue('paysystem_id');
			}
			return null;
		}

		/**
		 * Get value of field from author info page
		 * @param string $fieldName Field name
		 * @return mixed
		 */
		public function getAuthorInfoField($fieldName) {
			if (!$this->authorInfoPage instanceof iUmiObject) {
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
					return null;
				}

				$sel = new selector('objects');
				$sel->types('object-type')->id($iTypeId);
				$sel->limit(0, 1);
				$object = $sel->first();
				if (!$object) {
					return null;
				}
				$this->authorInfoPage = $object;
			}

			return $this->authorInfoPage->getValue($fieldName);
		}

		/**
		 * Check if this paysystem available and enabled
		 * @return boolean
		 */
		abstract public function enabled();

		/**
		 * Callback for payment system
		 * @return string
		 */
		abstract public function callback();

		/**
		 * Get URL for payment for order
		 * @param int $orderId ID of order for pay
		 * @return string
		 */
		abstract public function getPaymentUrl($orderId);

	}
