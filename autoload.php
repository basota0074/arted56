<?php
	/** @var array $classes конфигурация для автозагрузки классов модуля */
	$classes = [
		'iUmiSelection' => [
			dirname(__FILE__) . '/classes/system/iUmiSelection.php'
		],
		'umiSelection' => [
			dirname(__FILE__) . '/classes/system/umiSelection.php'
		],
		'iUmiSelectionsParser' => [
			dirname(__FILE__) . '/classes/system/iUmiSelectionsParser.php'
		],
		'umiSelectionsParser' => [
			dirname(__FILE__) . '/classes/system/umiSelectionsParser.php'
		],
		'umiBranch' => [
			dirname(__FILE__) . '/classes/system/umiBranch.php'
		],
	];