<?php

	/** Основной класс модуля "Каталог" для готовых решений */
	class catalog_custom {

		/**
		 * Конструктор
		 * @param catalog $module
		 */
		public function __construct(catalog $module) {
			$currentDir = __DIR__ . '/';
			$module->__loadLib('customMacros.php', $currentDir);
			$module->__implement('CatalogSolutionCustomMacros', true);
		}
	}
