<?php

	use UmiCms\Service;

	/** Основной класс модуля "Контент" для готовых решений */
	class content_custom {

		/**
		 * Конструктор
		 * @param content $module
		 */
		public function __construct(content $module) {
			$currentDir = __DIR__ . '/';

			if (Service::Request()->isAdmin()) {
				$module->__loadLib('customAdmin.php', $currentDir);
				$module->__implement('ContentSolutionAdmin', true);
			}

			$module->__loadLib('customMacros.php', $currentDir);
			$module->__implement('ContentSolutionCustomMacros', true);
		}
	}
