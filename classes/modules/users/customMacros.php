<?php

	use UmiCms\Service;

	/** Класс пользовательских методов для всех режимов */
	class UsersSolutionCustomMacros {

		/** @var users|UsersMacros $module */
		public $module;

		public function custom_registrate_do($template = 'default') {
			$_REQUEST['login'] = (string) getRequest('email');
			$_REQUEST['template'] = (string) $template;
			return $this->module->registrate_do();
		}

		public function custom_settings_do($template = 'default') {
			$_REQUEST['login'] = (string) getRequest('email');
			return $this->module->settings_do();
		}

		public function custom_login_do() {
			$login = getRequest('login');
			$password = getRequest('password');
			$ajax_message['status'] = 0;

			$buffer = Service::Response()
				->getCurrentBuffer();

			if ($login === '') {
				$ajax_message['status'] = 1;
				$buffer->push(json_encode($ajax_message));
				$buffer->end();
			}

			$permissions = permissionsCollection::getInstance();
			$auth = Service::Auth();

			$userId = $auth->checkLogin($login, $password);
			$user = umiObjectsCollection::getInstance()
				->getObject($userId);

			if ($user instanceof iUmiObject) {
				$auth->loginUsingId($user->getId());

				if ($permissions->isAdmin($user->getId())) {
					$session = Service::Session();
					$session->set('csrf_token', md5(mt_rand() . microtime()));
					$session->startActiveTime();
				}

				$oEventPoint = new umiEventPoint('users_login_successfull');
				$oEventPoint->setParam('user_id', $user->getId());
				$this->module->setEventPoint($oEventPoint);

				$buffer->push(json_encode($ajax_message));
				$buffer->end();
			} else {
				$oEventPoint = new umiEventPoint('users_login_failed');
				$oEventPoint->setParam('login', $login);
				$oEventPoint->setParam('password', $password);
				$this->module->setEventPoint($oEventPoint);

				$ajax_message['status'] = 1;

				$buffer->push(json_encode($ajax_message));
				$buffer->end();
			}

			$buffer->push(json_encode($ajax_message));
			$buffer->end();
		}

		public function user_type() {

			$result['type'] = 0;
			$result['admin'] = 0;

			$permissions = permissionsCollection::getInstance();
			$auth = Service::Auth();
			$userId = $auth->getUserId();
			if ($permissions->isAdmin($userId)) {
				$result['type'] = 'admin';
				$result['admin'] = 1;
			} else {
				$systemUsersPermissions = Service::SystemUsersPermissions();
				$guestId = $systemUsersPermissions->getGuestUserId();
				if ($guestId == $userId) {
					$result['type'] = 'guest';
				} else {
					$result['type'] = 'user';
				}
			}

			return $result;
		}
	}
