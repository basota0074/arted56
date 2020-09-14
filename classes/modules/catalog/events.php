<?php

	/** Events on eip page modifications */

	$oAdd = new umiEventListener('systemCreateElement', 'catalog', 'onAddCatalogObject');    // __custom_adm.php
	$oQuickAdd = new umiEventListener('eipQuickAdd', 'catalog', 'onAddCatalogObjectQuick');    // __custom_adm.php

	$oSave = new umiEventListener('eipSave', 'catalog', 'onSaveCatalogObject');    // __custom.php
	$oModify = new umiEventListener('systemModifyElement', 'catalog', 'onModifyCatalogObject');    //__custom_adm.php

	$oMove = new umiEventListener('systemMoveElement', 'catalog', 'onMoveCatalogObject');    //__custom_adm.php

	$oDelete = new umiEventListener('systemDeleteElement', 'catalog', 'onDeleteCatalogObject');    //__custom.php
	$oActivityUMI =
		new umiEventListener('systemSwitchElementActivity', 'catalog', 'onSwitchActivityCatalogObjectUmi');    // __custom.php и __custom_adm.php (из eip и /admin соответственно)

	$oActivityCustom = new umiEventListener('customElementActivityChanged', 'catalog', 'onSwitchActivityCatalogObject');    // __custom.php
