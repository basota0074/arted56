<?php

	/** Основной класс модуля "Интернет-магазин" для готовых решений */
	class emarket_custom {

		/**
		 * Конструктор
		 * @param emarket $module
		 */
		public function __construct(emarket $module) {
			$currentDir = __DIR__ . '/';
			$module->__loadLib('customMacros.php', $currentDir);
			$module->__implement('EmarketSolutionCustomMacros', true);
		}
	}
