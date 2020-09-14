<?php

	// Notification listeners
	new umiEventListener('order-status-changed', 'emarket', 'onStatusChangedCustom');
	new umiEventListener('systemModifyPropertyValue', 'emarket', 'onStatusChangedToReady');
	new umiEventListener('systemModifyObject', 'emarket', 'onModifyStatusObject');
