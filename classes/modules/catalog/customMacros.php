<?php

	/** Класс пользовательских методов для всех режимов */
	class CatalogSolutionCustomMacros {

		/** @var catalog $module */
		public $module;

		/**
		 * Список всех категорий, в т.ч. неактивных
		 * @param string $template
		 * @param bool $category_id
		 * @param bool $limit
		 * @param bool $ignore_paging
		 * @param int $i_need_deep
		 * @param bool $bWithInactive
		 * @return mixed
		 * @throws publicException
		 */
		public function getCategoryListFull(
			$template = 'default',
			$category_id = false,
			$limit = false,
			$ignore_paging = false,
			$i_need_deep = 0,
			$bWithInactive = false
		) {
			if (!$template) {
				$template = 'default';
			}
			list($template_block, $template_block_empty, $template_line) =
				def_module::loadTemplates('catalog/' . $template, 'category_block', 'category_block_empty', 'category_block_line');

			if (!$i_need_deep) {
				$i_need_deep = (int) getRequest('param4');
			}
			if (!$i_need_deep) {
				$i_need_deep = 0;
			}
			$i_need_deep = (int) $i_need_deep;
			if ($i_need_deep === -1) {
				$i_need_deep = 100;
			}

			if ((string) $category_id != '0') {
				$category_id = $this->module->analyzeRequiredPath($category_id);
			}

			$social_module = cmsController::getInstance()->getModule('social_networks');
			if ($social_module) {
				/** @var social_networks $social_module */
				$social = $social_module->getCurrentSocial();
			} else {
				$social = false;
			}

			if ($category_id === false) {
				throw new publicException(getLabel('error-page-does-not-exist', null, $category_id));
			}

			$hierarchy_type_id = umiHierarchyTypesCollection::getInstance()->getTypeByName('catalog', 'category')->getId();

			$per_page = $limit ?: $this->module->per_page;

			$curr_page = (int) getRequest('p');
			if ($ignore_paging) {
				$curr_page = 0;
			}

			$sel1 = new umiSelection;
			$sel1->addElementType($hierarchy_type_id);
			$sel1->addHierarchyFilter($category_id, $i_need_deep);
			$sel1->addActiveFilter(true);
			$sel1->addLimit($per_page, $curr_page);

			$result1 = umiSelectionsParser::runSelection($sel1);
			$total1 = umiSelectionsParser::runSelectionCounts($sel1);

			$result2 = [];
			$total2 = 0;
			if ($bWithInactive) {
				$sel2 = new umiSelection;
				$sel2->addElementType($hierarchy_type_id);
				$sel2->addHierarchyFilter($category_id, $i_need_deep);
				$sel2->addActiveFilter(false);
				$sel2->addLimit($per_page, $curr_page);

				$result2 = umiSelectionsParser::runSelection($sel2);
				$total2 = umiSelectionsParser::runSelectionCounts($sel2);
			}

			$result = array_merge($result1, $result2);
			$total = $total1 + $total2;

			if (($sz = umiCount($result)) > 0) {
				$block_arr = [];

				$lines = [];
				for ($i = 0; $i < $sz; $i++) {
					if ($i < $limit || !$limit) {
						$element_id = $result[$i];
						if ($social && !$social->isHierarchyAllowed($result[$i])) {
							continue;
						}
						$element = umiHierarchy::getInstance()->getElement($element_id);

						if (!$element) {
							continue;
						}

						$line_arr = [];
						$line_arr['attribute:id'] = $element_id;
						$line_arr['attribute:is-active'] = $element->getIsActive();
						$line_arr['void:alt_name'] = $element->getAltName();
						$line_arr['attribute:link'] = umiHierarchy::getInstance()->getPathById($element_id);
						$line_arr['xlink:href'] = 'upage://' . $element_id;
						$line_arr['node:text'] = $element->getName();

						$lines[] = def_module::parseTemplate($template_line, $line_arr, $element_id);
					}
				}

				$block_arr['attribute:category-id'] = $block_arr['void:category_id'] = $category_id;
				$block_arr['subnodes:items'] = $block_arr['void:lines'] = $lines;
				$block_arr['total'] = $total;
				$block_arr['per_page'] = $per_page;
				return def_module::parseTemplate($template_block, $block_arr, $category_id);
			}

			$block_arr = [];
			$block_arr['attribute:category-id'] = $block_arr['void:category_id'] = $category_id;
			return def_module::parseTemplate($template_block_empty, $block_arr, $category_id);
		}

		/**
		 * Список всех объектов каталога, в т.ч. и неактивных
		 * @param string $template
		 * @param bool $path
		 * @param bool $limit
		 * @param bool $ignore_paging
		 * @param int $i_need_deep
		 * @param bool $bWithInactive
		 * @return mixed
		 * @throws publicException
		 */
		public function getObjectsListFull(
			$template = 'default',
			$path = false,
			$limit = false,
			$ignore_paging = false,
			$i_need_deep = 0,
			$bWithInactive = false
		) {
			if (!$template) {
				$template = 'default';
			}

			if (!$i_need_deep) {
				$i_need_deep = (int) getRequest('param4');
			}
			if (!$i_need_deep) {
				$i_need_deep = 0;
			}
			$i_need_deep = (int) $i_need_deep;
			if ($i_need_deep === -1) {
				$i_need_deep = 100;
			}

			$hierarchy = umiHierarchy::getInstance();

			list($template_block, $template_block_empty, $template_block_search_empty, $template_line) =
				def_module::loadTemplates('catalog/' .
					$template, 'objects_block', 'objects_block_empty', 'objects_block_search_empty', 'objects_block_line');

			$hierarchy_type_id = umiHierarchyTypesCollection::getInstance()->getTypeByName('catalog', 'object')->getId();

			$category_id = $this->module->analyzeRequiredPath($path);

			if ($category_id === false && $path != KEYWORD_GRAB_ALL) {
				throw new publicException(getLabel('error-page-does-not-exist', null, $path));
			}

			$category_element = $hierarchy->getElement($category_id);

			$per_page = $limit ?: $this->module->per_page;
			$curr_page = getRequest('p');
			if ($ignore_paging) {
				$curr_page = 0;
			}

			$hierarchy_type = umiHierarchyTypesCollection::getInstance()->getType($hierarchy_type_id);
			$type_id = umiObjectTypesCollection::getInstance()->getBaseType($hierarchy_type->getName(), $hierarchy_type->getExt());

			if ($path === KEYWORD_GRAB_ALL) {
				$curr_category_id = cmsController::getInstance()->getCurrentElementId();
			} else {
				$curr_category_id = $category_id;
			}

			if ($path != KEYWORD_GRAB_ALL) {
				$type_id = $hierarchy->getDominantTypeId($curr_category_id, $i_need_deep, $hierarchy_type_id);
			}

			if (!$type_id) {
				$type_id = umiObjectTypesCollection::getInstance()->getBaseType($hierarchy_type->getName(), $hierarchy_type->getExt());
			}

			$sel1 = new umiSelection;
			$sel1->setElementTypeFilter();
			$sel1->addElementType($hierarchy_type_id);
			$sel1->addActiveFilter(true);

			if ($path != KEYWORD_GRAB_ALL) {
				$sel1->setHierarchyFilter();
				$sel1->addHierarchyFilter($category_id, $i_need_deep);
			}

			$sel1->setPermissionsFilter();
			$sel1->addPermissions();

			if ($type_id) {
				$this->module->autoDetectOrders($sel1, $type_id);
				$this->module->autoDetectFilters($sel1, $type_id);

				if ($this->module->isSelectionFiltered) {
					$template_block_empty = $template_block_search_empty;
					$this->module->isSelectionFiltered = false;
				}
			} else {
				$sel1->setOrderFilter();
				$sel1->setOrderByName();
			}

			if ($curr_page !== 'all') {
				$curr_page = (int) $curr_page;
				$sel1->setLimitFilter();
				$sel1->addLimit($per_page, $curr_page);
			}

			$result1 = umiSelectionsParser::runSelection($sel1);
			$total1 = umiSelectionsParser::runSelectionCounts($sel1);

			/**************************************/

			$result2 = [];
			$total2 = 0;
			if ($bWithInactive) {
				$sel2 = new umiSelection;
				$sel2->setElementTypeFilter();
				$sel2->addElementType($hierarchy_type_id);
				$sel2->addActiveFilter(false);

				if ($path != KEYWORD_GRAB_ALL) {
					$sel2->setHierarchyFilter();
					$sel2->addHierarchyFilter($category_id, $i_need_deep);
				}

				$sel2->setPermissionsFilter();
				$sel2->addPermissions();

				if ($type_id) {
					$this->module->autoDetectOrders($sel2, $type_id);
					$this->module->autoDetectFilters($sel2, $type_id);

					if ($this->module->isSelectionFiltered) {
						$template_block_empty = $template_block_search_empty;
						$this->module->isSelectionFiltered = false;
					}
				} else {
					$sel2->setOrderFilter();
					$sel2->setOrderByName();
				}

				if ($curr_page !== 'all') {
					$curr_page = (int) $curr_page;
					$sel2->setLimitFilter();
					$sel2->addLimit($per_page, $curr_page);
				}

				$result2 = umiSelectionsParser::runSelection($sel2);
				$total2 = umiSelectionsParser::runSelectionCounts($sel2);
			}

			/***********************************/

			$result = array_merge($result1, $result2);
			$total = $total1 + $total2;

			if (($sz = umiCount($result)) > 0) {
				$block_arr = [];

				$lines = [];
				for ($i = 0; $i < $sz; $i++) {
					$element_id = $result[$i];
					$element = umiHierarchy::getInstance()->getElement($element_id);

					if (!$element) {
						continue;
					}

					$line_arr = [];
					$line_arr['attribute:id'] = $element_id;
					$line_arr['attribute:is-active'] = $element->getIsActive();
					$line_arr['attribute:alt_name'] = $element->getAltName();
					$line_arr['attribute:link'] = umiHierarchy::getInstance()->getPathById($element_id);
					$line_arr['xlink:href'] = 'upage://' . $element_id;
					$line_arr['node:text'] = $element->getName();

					$lines[] = def_module::parseTemplate($template_line, $line_arr, $element_id);

					$this->module->pushEditable('catalog', 'object', $element_id);
					umiHierarchy::getInstance()->unloadElement($element_id);
				}

				$block_arr['subnodes:lines'] = $lines;
				$block_arr['numpages'] = umiPagenum::generateNumPage($total, $per_page);
				$block_arr['total'] = $total;
				$block_arr['per_page'] = $per_page;
				$block_arr['category_id'] = $category_id;

				if ($type_id) {
					$block_arr['type_id'] = $type_id;
				}

				return def_module::parseTemplate($template_block, $block_arr, $category_id);
			}

			$block_arr['numpages'] = umiPagenum::generateNumPage(0, 0);
			$block_arr['lines'] = '';
			$block_arr['total'] = 0;
			$block_arr['per_page'] = 0;
			$block_arr['category_id'] = $category_id;

			return def_module::parseTemplate($template_block_empty, $block_arr, $category_id);
		}

		/**
		 * Кастомный поиск
		 * @param bool $category_id
		 * @param string $group_names
		 * @param string $template
		 * @param bool $type_id
		 * @return mixed
		 * @throws coreException
		 */
		public function customSearch($category_id = false, $group_names = '', $template = 'default', $type_id = false) {
			if (!$template) {
				$template = 'default';
			}

			if ($type_id === false) {
				$category_id = $this->module->analyzeRequiredPath($category_id);
				if (!$category_id) {
					return '';
				}
			}

			list($template_block, $template_block_empty, $template_block_line, $template_block_line_text, $template_block_line_relation,
				$template_block_line_item_relation, $template_block_line_item_relation_separator, $template_block_line_price,
				$template_block_line_boolean, $template_block_line_symlink) =

				def_module::loadTemplates('catalog/' .
					$template, 'search_block', 'search_block_empty', 'search_block_line', 'search_block_line_text', 'search_block_line_relation', 'search_block_line_item_relation', 'search_block_line_item_relation_separator', 'search_block_line_price', 'search_block_line_boolean', 'search_block_line_symlink');

			$block_arr = [];

			if ($type_id === false) {
				$type_id = umiHierarchy::getInstance()->getDominantTypeId($category_id);
			}

			if ($type_id === null) {
				return '';
			}

			if (!($type = umiObjectTypesCollection::getInstance()->getType($type_id))) {
				trigger_error('Failed to load type', E_USER_WARNING);
				return '';
			}

			$fields = [];
			$groups = [];
			$lines = [];

			$group_names = trim($group_names);
			if ($group_names) {
				$group_names_arr = explode(' ', $group_names);
				foreach ($group_names_arr as $group_name) {
					$fields_group = $type->getFieldsGroupByName($group_name);

					if ($fields_group) {
						$groups[] = $fields_group;
					}
				}
			} else {
				$groups = $type->getFieldsGroupsList();
			}

			$lines_all = [];
			$groups_arr = [];

			/** @var iUmiFieldsGroup $fields_group */
			foreach ($groups as $fields_group) {
				$fields = $fields_group->getFields();

				$group_block = [];
				$group_block['attribute:name'] = $fields_group->getName();
				$group_block['attribute:title'] = $fields_group->getTitle();

				$lines = [];

				/**
				 * @var int $field_id
				 * @var iUmiField $field
				 */
				foreach ($fields as $field_id => $field) {
					if (!$field->getIsVisible()) {
						continue;
					}
					if (!$field->getIsInFilter()) {
						continue;
					}

					$line_arr = [];

					$field_type_id = $field->getFieldTypeId();
					$field_type = umiFieldTypesCollection::getInstance()->getFieldType($field_type_id);

					$data_type = $field_type->getDataType();

					$line = [];
					switch ($data_type) {
						case 'relation': {
							$line =
								$this->custom_parseSearchRelation($field, $template_block_line_relation, $template_block_line_item_relation, $template_block_line_item_relation_separator, $category_id, $type_id);
							break;
						}

						case 'text': {
							$line = $this->parseSearchText($field, $template_block_line_text);
							break;
						}

						case 'date': {
							$line = $this->parseSearchDate($field, $template_block_line_text);
							break;
						}

						case 'string': {
							$line = $this->parseSearchText($field, $template_block_line_text);
							break;
						}

						case 'wysiwyg': {
							$line = $this->parseSearchText($field, $template_block_line_text);
							break;
						}

						case 'float':
						case 'price': {
							$line = $this->parseSearchPrice($field, $template_block_line_price);
							break;
						}

						case 'int': {
							$line = $this->parseSearchInt($field, $template_block_line_text);
							break;
						}

						case 'boolean': {
							$line = $this->parseSearchBoolean($field, $template_block_line_boolean);
							break;
						}

						case 'symlink': {
							$line = $this->parseSearchSymlink($field, $template_block_line_symlink, $category_id);
							break;
						}

						default: {
							$line = "[search filter for \"{$data_type}\" not specified]";
							break;
						}
					}

					if (def_module::isXSLTResultMode()) {
						if (is_array($line)) {
							$line['attribute:data-type'] = $data_type;
						}
					}

					$line_arr['void:selector'] = $line;

					if (def_module::isXSLTResultMode()) {
						$lines[] = $line;
					} else {
						$lines[] = $tmp = def_module::parseTemplate($template_block_line, $line_arr);
						$lines_all[] = $tmp;
					}
				}

				if (empty($lines)) {
					continue;
				}

				$group_block['nodes:field'] = $lines;
				$groups_arr[] = $group_block;
			}

			$block_arr['void:items'] = $block_arr['void:lines'] = $lines_all;
			$block_arr['nodes:group'] = $groups_arr;
			$block_arr['attribute:category_id'] = $category_id;

			if (!$groups_arr && !$lines && !$this->module->isXSLTResultMode()) {
				return $template_block_empty;
			}

			return def_module::parseTemplate($template_block, $block_arr);
		}

		public function parseSearchRelation(iUmiField $field, $template, $template_item, $template_separator) {
			return $this->getDataModule()->parseSearchRelation($field, $template, $template_item, $template_separator);
		}

		public function parseSearchText(iUmiField $field, $template) {
			return $this->getDataModule()->parseSearchText($field, $template);
		}

		public function parseSearchPrice(iUmiField $field, $template) {
			return $this->getDataModule()->parseSearchPrice($field, $template);
		}

		public function parseSearchBoolean(iUmiField $field, $template) {
			return $this->getDataModule()->parseSearchBoolean($field, $template);
		}

		public function parseSearchInt(iUmiField $field, $template) {
			return $this->getDataModule()->parseSearchInt($field, $template);
		}

		public function parseSearchDate(iUmiField $field, $template) {
			return $this->getDataModule()->parseSearchDate($field, $template);
		}

		public function parseSearchSymlink(iUmiField $field, $template, $category_id) {
			return $this->getDataModule()->parseSearchSymlink($field, $template, $category_id);
		}

		public function applyFilterName(umiSelection $sel, $value) {
			return $this->getDataModule()->applyFilterName($sel, $value);
		}

		public function applyFilterText(umiSelection $sel, iUmiField $field, $value) {
			return $this->getDataModule()->applyFilterText($sel, $field, $value);
		}

		public function applyFilterInt(umiSelection $sel, iUmiField $field, $value) {
			return $this->getDataModule()->applyFilterInt($sel, $field, $value);
		}

		public function applyFilterRelation(umiSelection $sel, iUmiField $field, $value) {
			return $this->getDataModule()->applyFilterRelation($sel, $field, $value);
		}

		public function applyFilterPrice(umiSelection $sel, iUmiField $field, $value) {
			return $this->getDataModule()->applyFilterPrice($sel, $field, $value);
		}

		public function applyFilterDate(umiSelection $sel, iUmiField $field, $value) {
			return $this->getDataModule()->applyFilterDate($sel, $field, $value);
		}

		public function applyFilterFloat(umiSelection $sel, iUmiField $field, $value) {
			return $this->getDataModule()->applyFilterFloat($sel, $field, $value);
		}

		public function applyFilterBoolean(umiSelection $sel, iUmiField $field, $value) {
			return $this->getDataModule()->applyFilterBoolean($sel, $field, $value);
		}

		public static function protectStringVariable($stringVariable = '') {
			return __search_data::protectStringVariable($stringVariable);
		}

		public function applyKeyedFilters(umiSelection $sel, iUmiField $field, $values) {
			return $this->getDataModule()->applyKeyedFilters($sel, $field, $values);
		}

		/** @return def_module|data|DataCustomMacros */
		public function getDataModule() {
			static $dataModule;

			if (!$dataModule) {
				$dataModule = cmsController::getInstance()->getModule('data');
			}
			return $dataModule;
		}

		/** Подборка вариантов в зависимости от наличия товара (есть активные страницы)
		 * @param iUmiField $field
		 * @param $template
		 * @param $template_item
		 * @param $template_separator
		 * @param $category_id
		 * @param $type_id
		 * @return
		 */
		public function custom_parseSearchRelation(
			iUmiField $field,
			$template,
			$template_item,
			$template_separator,
			$category_id,
			$type_id
		) {
			return $this->getDataModule()->custom_parseSearchRelation($field, $template, $template_item, $template_separator, $category_id, $type_id);
		}

		/** Получение название каталога по умолчанию при импорте */
		public function getCatalogDefaultName() {
			$infoPageTitle = 'Авторская информация';
			$query = "SELECT id FROM cms3_object_types WHERE name='{$infoPageTitle}'";
			$typesResult = ConnectionPool::getInstance()->getConnection()->query($query)->fetch_row();
			$infoPageType = (int) array_shift($typesResult);

			$sel = new umiSelection();
			$sel->addObjectType($infoPageType);
			$sel->addLimit(1, 0);
			$result = umiSelectionsParser::runSelection($sel);

			$object = umiObjectsCollection::getInstance()->getObject($result[0]);

			$name = $object->getValue('catalog_import_default_name');
			$block_arr['name'] = $name;
			return def_module::parseTemplate([], $block_arr);
		}

		/**
		 * Является ли страница категорией и преобладают ли в ней товары, а не категории
		 * @param mixed $pageId
		 * @return mixed|string
		 */
		public function isCategory($pageId = 0) {
			$result = 0;

			$oElement = umiHierarchy::getInstance()->getElement($pageId);
			if ($oElement) {
				$sModule = $oElement->getModule();
				$sMethod = $oElement->getMethod();
				if ($sModule == 'catalog' && $sMethod == 'category') {
					$iDominantObjectType = umiHierarchy::getInstance()->getDominantTypeId($pageId);
					$iCategoryTypeId = umiObjectTypesCollection::getInstance()->getBaseType('catalog', 'category');
					if ($iDominantObjectType != $iCategoryTypeId) {
						$result = 1;
					}
				}
			}

			return def_module::parseTemplate([], ['iscategory' => $result]);
		}

		/*********** Some event handlers (thank you, edit-in-place)   ************
		 * @param $iCategoryId
		 */
		public function unsetCache($iCategoryId) {
			$sCacheFile = CURRENT_WORKING_DIR . '/sys-temp/runtime-cache/customCache';

			if (file_exists($sCacheFile)) {
				$arCache = file_get_contents($sCacheFile);
				$arCache = unserialize($arCache);
				if (is_array($arCache)) {
					if (isset($arCache['smartCatalogFilter'][$iCategoryId])) {
						unset($arCache['smartCatalogFilter'][$iCategoryId]);

						if (file_put_contents($sCacheFile, serialize($arCache))) {
							clearstatcache();
							@chmod($sCacheFile, 0777);
						}
					}
				}
			}
		}

		public function onDeleteCatalogObject(iUmiEventPoint $event) {
			if ($event->getMode() === 'after') {
				/** @var iUmiHierarchyElement $oElement */
				$oElement = $event->getRef('element');

				if ($oElement) {
					if ($oElement->getModule() == 'catalog') {
						$iParentId = $oElement->getParentId();

						$this->unsetCache($iParentId);
					}
				}
			}

			return true;
		}

		public function onSaveCatalogObject(iUmiEventPoint $event) {
			if ($event->getMode() === 'after') {
				/** @var iUmiHierarchyElement $oElement */
				$oElement = $event->getParam('obj');
				if ($oElement instanceof iUmiHierarchyElement) {
					$iParentId = $oElement->getParentId();
					$this->unsetCache($iParentId);
				}
			}

			return true;
		}

		public function onSwitchActivityCatalogObjectUmi(iUmiEventPoint $event) {
			if ($event->getMode() === 'after') {
				/** @var iUmiHierarchyElement $oElement */
				$oElement = $event->getRef('element');

				if ($oElement) {
					$iParentId = $oElement->getParentId();

					$this->unsetCache($iParentId);
				}
			}

			return true;
		}

		public function onSwitchActivityCatalogObject(iUmiEventPoint $event) {
			if ($event->getMode() === 'after') {
				/** @var iUmiHierarchyElement $oElement */
				$oElement = $event->getRef('element');

				if ($oElement) {
					$iParentId = $oElement->getParentId();

					$this->unsetCache($iParentId);
				}
			}

			return true;
		}

		public function onAddCatalogObject(iUmiEventPoint $event) {
			if ($event->getMode() === 'after') {
				/** @var iUmiHierarchyElement $oElement */
				$oElement = $event->getRef('element');

				if ($oElement) {
					$iParentId = $oElement->getParentId();

					$this->unsetCache($iParentId);
				}
			}

			return true;
		}

		public function onAddCatalogObjectQuick(iUmiEventPoint $event) {
			if ($event->getMode() === 'after') {
				$iElementId = $event->getParam('elementId');
				/** @var iUmiHierarchyElement $oElement */
				$oElement = umiHierarchy::getInstance()->getElement($iElementId);

				if ($oElement) {
					$iParentId = $oElement->getParentId();

					$this->unsetCache($iParentId);
				}
			}

			return true;
		}

		public function onMoveCatalogObject(iUmiEventPoint $event) {
			if ($event->getMode() === 'before') {
				$iElementId = $event->getParam('elementId');
				/** @var iUmiHierarchyElement $oElement */
				$oElement = umiHierarchy::getInstance()->getElement($iElementId);

				if ($oElement) {
					$iParentId = $oElement->getParentId();

					$this->unsetCache($iParentId);
				}
			} elseif ($event->getMode() === 'after') {
				$iElementId = $event->getParam('elementId');
				/** @var iUmiHierarchyElement $oElement */
				$oElement = umiHierarchy::getInstance()->getElement($iElementId);

				if ($oElement) {
					$iParentId = $oElement->getParentId();

					$this->unsetCache($iParentId);
				}
			}

			return true;
		}

		public function onModifyCatalogObject(iUmiEventPoint $event) {
			/** @var iUmiHierarchyElement $oElement */
			$oElement = $event->getRef('element');

			if ($oElement) {
				$iParentId = $oElement->getParentId();

				$this->unsetCache($iParentId);
			}

			return true;
		}

		public function getSpecialOffers() {
			$sel = new selector('pages');
			$sel->types('hierarchy-type')->name('catalog', 'object');
			$sel->where('special_offer')->equals('1');

			$res = $sel->result();
			$total = umiCount($res);

			$block_arr = [];
			$block_arr['total'] = $total;

			if ($total > 0) {
				$pages = [];
				for ($i = 0; $i < $total; $i++) {
					/** @var iUmiHierarchyElement $element */
					$element = $res[$i];

					if (!$element) {
						continue;
					}

					$element_id = $element->getId();

					$page = [];
					$page['attribute:id'] = $element_id;
					$page['attribute:is-active'] = $element->getIsActive();
					$page['attribute:alt_name'] = $element->getAltName();
					$page['attribute:link'] = umiHierarchy::getInstance()->getPathById($element_id);
					$page['xlink:href'] = 'upage://' . $element_id;
					$page['name'] = $element->getName();

					$pages[] = $page;

					umiHierarchy::getInstance()->unloadElement($element_id);
				}

				$block_arr['nodes:page'] = $pages;
			}
			return def_module::parseTemplate([], $block_arr);
		}

		/**
		 * Производит определение параметров сортировки и применяет их к переданной выборке
		 * @param umiSelection $sel выборка, к которой будет применена сортировка
		 * @param int $objectTypeId ID типа данных,
		 * в котором находится поле по которому будет произведена сортировка
		 * @return bool
		 */
		public function autoDetectOrders(umiSelection $sel, $objectTypeId) {
			if (!array_key_exists('order_filter', $_REQUEST)) {
				return false;
			}

			$sel->setOrderFilter();
			$type = umiObjectTypesCollection::getInstance()
				->getType($objectTypeId);
			$orderFilter = getRequest('order_filter');

			foreach ($orderFilter as $fieldName => $direction) {
				if ($direction === 'asc') {
					$direction = true;
				}
				if ($direction === 'desc') {
					$direction = false;
				}
				$direction = (bool) $direction;

				if ($fieldName == 'name') {
					$sel->setOrderByName($direction);
					continue;
				}

				if ($fieldName == 'ord') {
					$sel->setOrderByOrd($direction);
					continue;
				}

				if ($type) {
					$fieldId = $type->getFieldId($fieldName);
					if ($fieldId) {
						$sel->setOrderByProperty($fieldId, $direction);
					}
				}
			}
		}

		/**
		 * Производит определение параметров фильтрации
		 * @param umiSelection $sel выборка, к которой будет применена фильтрация
		 * @param int $object_type_id ID типа данных, в котором находятся поля, по которым будет
		 * произведена фильтрация
		 * @return bool
		 * @throws coreException
		 * @throws publicException
		 */
		public function autoDetectFilters(umiSelection $sel, $object_type_id) {
			if (getRequest('search-all-text') !== null) {
				$searchStrings = getRequest('search-all-text');
				if (is_array($searchStrings)) {
					foreach ($searchStrings as $searchString) {
						if ($searchString) {
							$sel->searchText($searchString);
						}
					}
				}
			}

			if (array_key_exists('fields_filter', $_REQUEST)) {
				$cmsController = cmsController::getInstance();
				$data_module = $cmsController->getModule('data');
				/** @var data|DataCustomMacros $data_module */
				if (!$data_module instanceof data) {
					throw new publicException('Need data module installed to use dynamic filters');
				}
				$sel->setPropertyFilter();

				$type = umiObjectTypesCollection::getInstance()->getType($object_type_id);

				$order_filter = getRequest('fields_filter');
				if (!is_array($order_filter)) {
					return false;
				}

				foreach ($order_filter as $field_name => $value) {
					if ($field_name == 'name') {
						$data_module->applyFilterName($sel, $value);
						continue;
					}

					$field_id = $type->getFieldId($field_name);

					if ($field_id) {
						$this->isSelectionFiltered = true;
						$field = umiFieldsCollection::getInstance()->getField($field_id);

						$field_type_id = $field->getFieldTypeId();
						$field_type = umiFieldTypesCollection::getInstance()->getFieldType($field_type_id);

						$data_type = $field_type->getDataType();

						switch ($data_type) {
							case 'text': {
								$data_module->applyFilterText($sel, $field, $value);
								break;
							}

							case 'wysiwyg': {
								$data_module->applyFilterText($sel, $field, $value);
								break;
							}

							case 'string': {
								$data_module->applyFilterText($sel, $field, $value);
								break;
							}

							case 'tags': {
								$tmp = array_extract_values($value);
								if (empty($tmp)) {
									break;
								}
							}
							case 'boolean': {
								$data_module->applyFilterBoolean($sel, $field, $value);
								break;
							}

							case 'int': {
								$data_module->applyFilterInt($sel, $field, $value);
								break;
							}

							case 'symlink':
							case 'relation': {
								$data_module->applyFilterRelation($sel, $field, $value);
								break;
							}

							case 'float': {
								$data_module->applyFilterFloat($sel, $field, $value);
								break;
							}

							case 'price': {
								$emarket = $cmsController->getModule('emarket');
								/** @var emarket|EmarketMacros $emarket */
								if ($emarket instanceof emarket) {
									$currencies = $emarket->getCurrencyFacade();
									$defaultCurrency = $currencies->getDefault();
									$currentCurrency = $currencies->getCurrent();

									$prices = $emarket->formatCurrencyPrice($value, $defaultCurrency, $currentCurrency);

									foreach ($value as $index => &$void) {
										$void = getArrayKey($prices, $index);
									}

									unset($void);
								}

								$data_module->applyFilterPrice($sel, $field, $value);
								break;
							}

							case 'file':
							case 'img_file':
							case 'swf_file':
							case 'video_file': {
								$data_module->applyFilterInt($sel, $field, $value);
								break;
							}

							case 'date': {
								$data_module->applyFilterDate($sel, $field, $value);
								break;
							}

							default: {
								break;
							}
						}
					} else {
						continue;
					}
				}
			} else {
				return false;
			}
		}
	}
