<?php

	use UmiCms\Service;

	/** Класс пользовательских методов административной панели */
	class ContentSolutionAdmin {

		/** @var content $module */
		public $module;

		/** @var ContentAdmin базовый класс административной панели модуля */
		public $admin;

		/**
		 * Конструктор
		 * @param content $module
		 */
		public function __construct(content $module) {
			$this->admin = $module->getImplementedInstance($module::ADMIN_CLASS);
		}

		public function adminsitetree() {
			$domains = Service::DomainCollection()->getList();
			$permissions = permissionsCollection::getInstance();
			$auth = Service::Auth();
			$user_id = $auth->getUserId();

			$this->admin->setDataType('list');
			$this->admin->setActionType('view');

			/**
			 * @var int $i
			 * @var iDomain $domain
			 */
			foreach ($domains as $i => $domain) {
				$domain_id = $domain->getId();

				if (!$permissions->isAllowedDomain($user_id, $domain_id)) {
					unset($domains[$i]);
				}
			}

			$data = $this->admin->prepareData($domains, 'domains');

			$this->admin->setData($data, umiCount($domains));
			$this->admin->doData();
		}

	}
