<?php

	new umiEventListener('systemCreateElement', 'content', 'onAfterAddElement'); //Запрет на создание "Авторской информации" + перемещение страницы в начало
	new umiEventListener('eipQuickAdd', 'content', 'onAfterQuickAddElement'); //перемещение страницы в начало

	new umiEventListener('systemCreateElement', 'content', 'onAfterAddElementSetMenuVisible'); //Установка галочек для видимости страницы в меню
	new umiEventListener('eipQuickAdd', 'content', 'onAfterQuickAddElementMenuVisible'); //Установка галочек для видимости страницы в меню

	new umiEventListener('exchangeOnAddElement', 'content', 'onAfterImportElementMenuVisible'); //Установка галочек для видимости страницы в меню при импорте
	new umiEventListener('exchangeOnUpdateElement', 'content', 'onAfterImportElementMenuVisible'); //Установка галочек для видимости страницы в меню при импорте

	new umiEventListener('systemCreateElement', 'content', 'clearCache'); //Удаляем статический кэш
	new umiEventListener('eipQuickAdd', 'content', 'clearCache'); //Удаляем статический кэш
	new umiEventListener('systemModifyElement', 'content', 'clearCache'); //Удаляем статический кэш
	new umiEventListener('eipSave', 'content', 'clearCache'); //Удаляем статический кэш
	new umiEventListener('systemMoveElement', 'content', 'clearCache'); //Удаляем статический кэш
	new umiEventListener('systemSwitchElementActivity', 'content', 'clearCache'); //Удаляем статический кэш
	new umiEventListener('systemDeleteElement', 'content', 'clearCache'); //Удаляем статический кэш
	new umiEventListener('exchangeOnAddElement', 'content', 'clearCache'); //Удаляем статический кэш
	new umiEventListener('exchangeOnUpdateElement', 'content', 'clearCache'); //Удаляем статический кэш
