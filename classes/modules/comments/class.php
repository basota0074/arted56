<?php

	/** Основной класс модуля "Комментарии" для готовых решений */
	class comments_custom {

		/**
		 * Конструктор
		 * @param comments $module
		 */
		public function __construct(comments $module) {
			$currentDir = __DIR__ . '/';
			$module->__loadLib('customMacros.php', $currentDir);
			$module->__implement('CommentsSolutionCustomMacros', true);
		}
	}
