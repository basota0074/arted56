<?php

	/** Основной класс модуля "Шаблоны данных" для готовых решений */
	class data_custom {

		/**
		 * Конструктор
		 * @param data $module
		 */
		public function __construct(data $module) {
			$currentDir = __DIR__ . '/';
			$module->__loadLib('customMacros.php', $currentDir);
			$module->__implement('DataSolutionCustomMacros', true);
		}
	}
