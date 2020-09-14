<?php

	/** Основной класс модуля "Конструктор форм" для готовых решений */
	class webforms_custom {

		/**
		 * Конструктор
		 * @param webforms $module
		 */
		public function __construct(webforms $module) {
			$currentDir = __DIR__ . '/';
			$module->__loadLib('customMacros.php', $currentDir);
			$module->__implement('WebformsSolutionCustomMacros', true);
		}
	}
