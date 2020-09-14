<?php

	/** Класс пользовательских методов для всех режимов */
	class CommentsSolutionCustomMacros {

		/** @var comments $module */
		public $module;

		/**
		 * Установка чекбоксов комментарию
		 * @param iUmiEventPoint $event
		 */
		public function onCommentPostSetCheckboxes(iUmiEventPoint $event) {
			if ($event->getMode() == 'after') {
				$commentId = $event->getParam('message_id');
				$oCommentElement = umiHierarchy::getInstance()->getElement($commentId, true);
				$oCommentElement->robots_deny = true;
				$oCommentElement->is_unindexed = true;
				$oCommentElement->commit();
			}
		}

		/**
		 * Установка оценки
		 * @param iUmiEventPoint $event
		 */
		public function onCommentPostSetGrade(iUmiEventPoint $event) {
			if ($event->getMode() == 'after') {
				$grade = (string) getRequest('grade');
				$commentId = $event->getParam('message_id');
				$oCommentElement = umiHierarchy::getInstance()->getElement($commentId, true);
				$oCommentElement->setValue('grade', $grade);
				$oCommentElement->commit();
			}
		}
	}
