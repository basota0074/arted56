<?php

	/** Основной класс модуля "Пользователи" для готовых решений */
	class users_custom {

		/**
		 * Конструктор
		 * @param users $module
		 */
		public function __construct(users $module) {
			$currentDir = __DIR__ . '/';
			$module->__loadLib('customMacros.php', $currentDir);
			$module->__implement('UsersSolutionCustomMacros', true);
		}
	}
