<?php

	use UmiCms\Service;

	/** Класс пользовательских методов для всех режимов */
	class DataSolutionCustomMacros {

		/** @var data $module */
		public $module;

		public function custom_parseSearchRelation(
			iUmiField $field,
			$template,
			$template_item,
			$template_separator,
			$category_id,
			$type_id
		) {
			$block_arr = [];

			$name = $field->getName();
			$title = $field->getTitle();

			$guide_id = $field->getGuideId();
			$guide_items = $this->getSmartCatalogGuidedItems($guide_id, $field, $category_id, $type_id);

			$fields_filter = getRequest('fields_filter');
			$value = getArrayKey($fields_filter, $name);

			$items = [];
			$i = 0;
			$sz = umiCount($guide_items);

			$is_tpl = !def_module::isXSLTResultMode();
			if (!$is_tpl) {
				$template_item = true;
			}

			$unfilter_link = '';

			foreach ($guide_items as $object_id => $object_name) {
				if (is_array($value)) {
					$selected = in_array($object_id, $value) ? 'selected' : '';
				} else {
					$selected = ($object_id == $value) ? 'selected' : '';
				}

				if ($template_item) {
					$line_arr = [];
					$line_arr['attribute:id'] = $line_arr['void:object_id'] = $object_id;
					$line_arr['node:object_name'] = $object_name;

					$params = $_GET;
					unset($params['path']);
					unset($params['p']);
					$params['fields_filter'][$name] = $object_id;
					$filter_link = '?' . http_build_query($params, '', '&amp;');

					unset($params['fields_filter'][$name]);
					$unfilter_link = '?' . http_build_query($params, '', '&amp;');

					$line_arr['attribute:filter_link'] = $filter_link;
					$line_arr['attribute:unfilter_link'] = $unfilter_link;

					if ($selected) {
						$line_arr['attribute:selected'] = 'selected';
					}

					$items[] = def_module::parseTemplate($template_item, $line_arr);

					if (++$i < $sz) {
						if ($is_tpl) {
							$items[] = $template_separator;
						}
					}
				} else {
					$items[] = "<option value=\"{$object_id}\" {$selected}>{$object_name}</option>";
				}
			}

			$block_arr['attribute:unfilter_link'] = $unfilter_link;
			$block_arr['attribute:name'] = $name;
			$block_arr['attribute:title'] = $title;
			$block_arr['subnodes:values'] = $block_arr['void:items'] = $items;
			$block_arr['void:selected'] = $value ? '' : 'selected';
			return def_module::parseTemplate($template, $block_arr);
		}

		/**
		 * Получение только тех элементов, для которых есть товары в каталоге
		 * Структура кеша - это сериализованный массив вида:
		 * array(
		 * [id категории] => array(
		 * [get-запрос] => array(
		 * array(
		 * [timestamp] => 000000000,
		 * [items] => array(
		 * [guide id] => array(guide_item_id_1, guide_item_id_2, ...),
		 * ...
		 * )
		 * )
		 * ),
		 * ...
		 * ),
		 * ...
		 * )
		 * @param $guide_id
		 * @param iUmiField $field
		 * @param $category_id
		 * @param $type_id
		 * @return array
		 */
		public function getSmartCatalogGuidedItems($guide_id, iUmiField $field, $category_id, $type_id) {
			$sCacheFile = CURRENT_WORKING_DIR . '/sys-temp/runtime-cache/customCache';

			$sCurrentFiltersSet = mb_substr($_SERVER['REQUEST_URI'], mb_strpos($_SERVER['REQUEST_URI'], '?'));
			$sCurrentFiltersSet = ($sCurrentFiltersSet == '') ? '?' : $sCurrentFiltersSet;

			if (file_exists($sCacheFile)) {
				$arCache = file_get_contents($sCacheFile);
				$arCache = unserialize($arCache);
				if (is_array($arCache)) {
					$iCacheLifeTime = 60 * 60 * 24; //24 часа
					if (isset($arCache['smartCatalogFilter'])
						&& isset($arCache['smartCatalogFilter'][$category_id])
						&& isset($arCache['smartCatalogFilter'][$category_id][$sCurrentFiltersSet])
						&& isset($arCache['smartCatalogFilter'][$category_id][$sCurrentFiltersSet]['items'])
						&& isset($arCache['smartCatalogFilter'][$category_id][$sCurrentFiltersSet]['items'][$guide_id])) {
						//Проверка на время
						if (isset($arCache['smartCatalogFilter'][$category_id][$sCurrentFiltersSet]['timestamp']) &&
							($arCache['smartCatalogFilter'][$category_id][$sCurrentFiltersSet]['timestamp'] >
								($_SERVER['REQUEST_TIME'] - $iCacheLifeTime))) {
							return $arCache['smartCatalogFilter'][$category_id][$sCurrentFiltersSet]['items'][$guide_id];
						}
					}
				}
			}

			$result = $this->setSmartCatalogGuidedItems($guide_id, $field, $category_id, $type_id);

			return $result;
		}

		/**
		 * Записать в кеш умный справочник для фильтров
		 * @param $guide_id
		 * @param iUmiField $field
		 * @param $category_id
		 * @param $type_id
		 * @return array
		 * @throws coreException
		 */
		public function setSmartCatalogGuidedItems($guide_id, iUmiField $field, $category_id, $type_id) {
			$sCacheFile = CURRENT_WORKING_DIR . '/sys-temp/runtime-cache/customCache';
			$oHierarchyType = umiHierarchyTypesCollection::getInstance()->getTypeByName('catalog', 'object');
			$iHierarchyTypeId = $oHierarchyType->getId();

			$arCache = [];
			if (file_exists($sCacheFile)) {
				$arCache = file_get_contents($sCacheFile);
				$arCache = unserialize($arCache);
			}

			$sCurrentFiltersSet = mb_substr($_SERVER['REQUEST_URI'], mb_strpos($_SERVER['REQUEST_URI'], '?'));
			$sCurrentFiltersSet = ($sCurrentFiltersSet == '') ? '?' : $sCurrentFiltersSet;

			if (!isset($arCache['smartCatalogFilter'])) {
				$arCache['smartCatalogFilter'] = [];
			}
			if (!isset($arCache['smartCatalogFilter'][$category_id])) {
				$arCache['smartCatalogFilter'][$category_id] = [];
			}
			if (!isset($arCache['smartCatalogFilter'][$category_id][$sCurrentFiltersSet])) {
				$arCache['smartCatalogFilter'][$category_id][$sCurrentFiltersSet] = [];
			}
			if (!isset($arCache['smartCatalogFilter'][$category_id][$sCurrentFiltersSet]['items'])) {
				$arCache['smartCatalogFilter'][$category_id][$sCurrentFiltersSet]['items'] = [];
			}

			$arSmartGuideItems = [];

			$arGuideValues = umiObjectsCollection::getInstance()->getGuidedItems($guide_id);

			foreach ($arGuideValues as $iItemId => $sItemName) {
				$sel = new umiSelection;
				$sel->addHierarchyFilter($category_id);
				$sel->addElementType($iHierarchyTypeId);
				$sel->addObjectType($type_id);

				$sel->addPropertyFilterEqual($field->getId(), $iItemId);
				$this->module->autoDetectFilters($sel, $type_id);

				$arResult = umiSelectionsParser::runSelection($sel);

				if (umiCount($arResult) > 0) {
					$arSmartGuideItems[$iItemId] = $sItemName;
				}
			}

			$arCache['smartCatalogFilter'][$category_id][$sCurrentFiltersSet]['items'][$guide_id] = $arSmartGuideItems;
			$arCache['smartCatalogFilter'][$category_id][$sCurrentFiltersSet]['timestamp'] = $_SERVER['REQUEST_TIME'];

			if (file_put_contents($sCacheFile, serialize($arCache))) {
				clearstatcache();
				@chmod($sCacheFile, 0777);
			}

			return $arSmartGuideItems;
		}

		/**
		 * Устанавливает директорию, в рамках которой производятся работы с файлами
		 * @return mixed|string
		 */
		public function setupCwd() {
			$this->cwd = str_replace("\\", '/', realpath(USER_FILES_PATH));
			$newCwd = getRequest('folder');

			if ($newCwd) {
				$newCwd = rtrim(base64_decode($newCwd), "/\\");
				$newCwd = str_replace("\\", '/', $newCwd);

				if ($this->checkPath($newCwd)) {
					$this->cwd = str_replace("\\", '/', realpath(CURRENT_WORKING_DIR . $newCwd));
				}
			}

			return $this->cwd;
		}

		/** Загрузка частичного списка файлов - для динамической подгрузки средствами ajax */
		public function getfilelistPartial() {
			$this->module->flushAsXML('getfilelistPartial');
			$this->setupCwd();

			$param = [
				['delete', 'unlink', 1],
				['copy', 'copy', 2],
				['move', 'rename', 2],
			];

			for ($i = 0; $i < umiCount($param); $i++) {
				if ($param != 'copy' && isDemoMode()) {
					continue; // disable in demo
				}

				if (isset($_REQUEST[$param[$i][0]]) && !empty($_REQUEST[$param[$i][0]])) {
					foreach ($_REQUEST[$param[$i][0]] as $item) {
						$item = CURRENT_WORKING_DIR . base64_decode($item);
						$arguments = [$item];
						if ($param[$i][2] > 1) {
							$arguments[] = $this->cwd . '/' . basename($item);
						}
						@call_user_func_array($param[$i][1], $arguments);
					}
				}
			}

			$imageExt = ['jpg', 'jpeg', 'gif', 'png'];
			$sizeMeasure = ['b', 'Kb', 'Mb', 'Gb', 'Tb'];
			$allowedExt = true;
			if (isset($_REQUEST['showOnlyImages'])) {
				$allowedExt = $imageExt;
			} else {
				if (isset($_REQUEST['showOnlyVideos'])) {
					$allowedExt = ['flv', 'mp4'];
				} else {
					if (isset($_REQUEST['showOnlyMedia'])) {
						$allowedExt =
							['swf', 'flv', 'dcr', 'mov', 'qt', 'mpg', 'mp3', 'mp4', 'mpeg', 'avi', 'wmv', 'wm', 'asf', 'asx', 'wmx', 'wvx', 'rm', 'ra', 'ram'];
					}
				}
			}

			$directory = new DirectoryIterator($this->cwd);

			$cwd = mb_substr($this->cwd, mb_strlen(CURRENT_WORKING_DIR));

			$warning = false;
			$filesData = [];
			foreach ($directory as $file) {
				if ($file->isDir()) {
					continue;
				}
				if ($file->isDot()) {
					continue;
				}
				$name = $file->getFilename();
				$ext = mb_strtolower(mb_substr($name, mb_strrpos($name, '.') + 1));
				if ($allowedExt !== true && !in_array($ext, $allowedExt)) {
					continue;
				}

				$ts = $file->getCTime();
				$time = date('G:i, d.m.Y', $ts);
				$size = $file->getSize();

				$img = $file;

				$sCharset = detectCharset($name);
				if (function_exists('iconv') && $sCharset !== 'UTF-8') {
					$warning = 'Error: Присутствуют файлы с недопустимыми названиями! Ошибка: http://errors.umi-cms.ru/13050/';
					continue;
				}

				if (!empty($ext)) {
					$sCharset = detectCharset($ext);
					if (function_exists('iconv') && $sCharset !== 'UTF-8') {
						continue;
					}
				}

				$file = [
					'attribute:name' => $name,
					'attribute:type' => $ext,
					'attribute:size' => $size,
					'attribute:ctime' => $time,
					'attribute:timestamp' => $ts
				];

				$i = 0;
				while ($size > 1024.0) {
					$size /= 1024;
					$i++;
				}
				$convertedSize = (int) round($size);
				if ($convertedSize == 1 && (int) floor($size) != $convertedSize) {
					$i++;
				}
				$file['attribute:converted-size'] = $convertedSize . $sizeMeasure[$i];
				if (in_array($ext, $imageExt) && $info = @getimagesize($img->getPath() . '/' . $img->getFilename())) {
					$file['attribute:mime'] = $info['mime'];
					$file['attribute:width'] = $info[0];
					$file['attribute:height'] = $info[1];
				}
				$filesData[] = $file;
			}

			$arResult = [
				'attribute:folder' => $cwd,
				'data' => [
					'list' => [
						'files' => ['nodes:file' => $filesData],
					]
				],
			];

			if ($warning != '') {
				$arResult['data']['warning'] = $warning;
			}

			$iLimit = isset($_REQUEST['limit']) ? (int) $_REQUEST['limit'] : 0;
			$iOffset = isset($_REQUEST['offset']) ? (int) $_REQUEST['offset'] : 0;

			if ($iLimit > 0) {
				$arFilesListFull = $arResult['data']['list']['files']['nodes:file'];
				$iTotal = umiCount($arFilesListFull);

				$arFilesListPortion = array_slice($arFilesListFull, $iOffset, $iLimit);

				$arResult['data']['list']['files']['nodes:file'] = $arFilesListPortion;
				$arResult['data']['total'] = $iTotal;
				$arResult['data']['offset'] = $iOffset;
				$arResult['data']['loaded'] = umiCount($arFilesListPortion);
			}

			return $arResult;
		}

		/**
		 * Кастомизация нового файлового менеджера
		 * @param string|bool $needInfo - если указан как getSystemInfo,
		 * то макрос отдаёт json с необходимыми для файлового менеджера параметрами
		 */
		public function elfinder_connector_custom($needInfo = false) {
			$needInfo = (!$needInfo) ? getRequest('param0') : $needInfo;
			if ($needInfo == 'getSystemInfo') {
				$arData = [
					'maxFilesCount' => ini_get('max_file_uploads') ?: 20,
				];
				$this->module->flush(json_encode($arData), 'text/javascript');
				return;
			}
			$elfClasses = CURRENT_WORKING_DIR . '/styles/common/other/elfinder/php/';
			require_once $elfClasses . 'elFinderConnector.class.php';
			//require_once $elfClasses . 'elFinder.class.php';
			require_once $elfClasses . 'elFinder.umiru.class.php';
			require_once $elfClasses . 'elFinderVolumeDriver.class.php';
			require_once $elfClasses . 'elFinderVolumeLocalFileSystem.class.php';
			require_once $elfClasses . 'elFinderVolumeUmiLocalFileSystem.class.php';
			require_once $elfClasses . 'elFinderVolumeUmiruLocalFileSystem.class.php';

			// full access mode for filemanager module (?full-access=1)
			$isFullAccess = (bool) getRequest('full-access');
			function elfinder_full_access($attr, $path, $data, $volume) {
				return startsWith(basename($path), '.')
					? !($attr == 'read' || $attr == 'write')
					: ($attr == 'read' || $attr == 'write');
			}

			function elfinder_access($attr, $path, $data, $volume) {
				if (startsWith(basename($path), '.')) {
					return !($attr == 'read' || $attr == 'write');
				}

				if (isDemoMode()) {
					return !($attr == 'write' || $attr == 'hidden');
				}
				return ($attr == 'read' || $attr == 'write');
			}

			/**
			 * Проверка имени файла/папки
			 *
			 * @param mixed $sName
			 * @return boolean
			 */
			function checkName($sName) {
				$bNotStartedWithDot = preg_match('/^[^\.]/', $sName);
				if (!$bNotStartedWithDot) {
					return false;
				}

				$bForbiddenExtension = preg_match('/^.*\.(php|pl|sh|exe|msi|com|bat|sql|js|ini|htaccess)$/', $sName);
				if ($bForbiddenExtension) {
					return false;
				}

				return true;
			}

			$opts = [
				//'debug' => true,
				'roots' => [
					[
						'id' => 'images',
						'driver' => 'UmiruLocalFileSystem',
						'path' => CURRENT_WORKING_DIR . '/images/cms/data',
						'startPath' => CURRENT_WORKING_DIR . '/images/cms/data',
						'alias' => 'Изображения',
						'URL' => '/images/cms/data/',
						'accessControl' => $isFullAccess ? 'elfinder_full_access' : 'elfinder_access',
						'acceptedName' => 'checkName',
					],
					[
						'id' => 'files',
						'driver' => 'UmiruLocalFileSystem',   // driver for accessing file system (REQUIRED)
						'path' => CURRENT_WORKING_DIR . '/files/',         // path to files (REQUIRED)
						'alias' => 'Файлы',
						'URL' => '/files/', // URL to files (REQUIRED)
						'accessControl' => $isFullAccess ? 'elfinder_full_access' : 'elfinder_access',
						'acceptedName' => 'checkName',
					],
				],
			];

			// run elFinder
			$connector = new elFinderConnector(new elFinderUmiru($opts));
			$connector->run();
		}

		public function getElfinderHash($path) {
			if ($path === '') {
				return '';
			}

			$path = str_replace('\\', '/', realpath('./' . trim($path, "./\\")));
			$auth = Service::Auth();
			$userId = $auth->getUserId();
			$user = umiObjectsCollection::getInstance()->getObject($userId);

			$source = '';
			$filemanagerDirectory = $user->getValue('filemanager_directory');

			if ($filemanagerDirectory) {
				$i = 1;
				$directories = explode(',', $filemanagerDirectory);
				foreach ($directories as $directory) {
					$directory = trim($directory);
					$directory = trim($directory, '/');
					if ($directory === '') {
						continue;
					}

					$directoryPath = CURRENT_WORKING_DIR . '/' . $directory;
					if (!contains($directoryPath, CURRENT_WORKING_DIR) || !is_dir($directoryPath)) {
						continue;
					}

					if (contains($path, $directory)) {
						$source = 'files' . $i;
						$path = trim(str_replace(CURRENT_WORKING_DIR . '/' . $directory, '', $path), '/');
						break;
					}

					$i++;
				}
			} else {
				$images_path = str_replace('\\', '/', realpath(CURRENT_WORKING_DIR . '/images/cms/data'));
				$files_path = str_replace('\\', '/', realpath(CURRENT_WORKING_DIR . '/files'));
				if (startsWith($path, $images_path)) {
					$path = trim(str_replace($images_path, '', $path), '/');
					$source = 'images';
				} elseif (startsWith($path, $files_path)) {
					$path = trim(str_replace($files_path, '', $path), '/');
					$source = 'files';
				}
			}

			$path = str_replace('/', DIRECTORY_SEPARATOR, $path);
			$hash = strtr(base64_encode($path), '+/=', '-_.');
			$hash = rtrim($hash, '.');

			return $hash !== '' ? 'umiru' . $source . '_' . $hash : '';
		}

		public function parseSearchRelation(iUmiField $field, $template, $template_item, $template_separator) {
			$block_arr = [];

			$name = $field->getName();
			$title = $field->getTitle();

			$guide_id = $field->getGuideId();
			$guide_items = umiObjectsCollection::getInstance()->getGuidedItems($guide_id);

			$fields_filter = getRequest('fields_filter');
			$value = getArrayKey($fields_filter, $name);

			$items = [];
			$i = 0;
			$sz = umiCount($guide_items);

			$is_tpl = !def_module::isXSLTResultMode();
			if (!$is_tpl) {
				$template_item = true;
			}

			$unfilter_link = '';

			foreach ($guide_items as $object_id => $object_name) {
				if (is_array($value)) {
					$selected = in_array($object_id, $value) ? 'selected' : '';
				} else {
					$selected = ($object_id == $value) ? 'selected' : '';
				}

				if ($template_item) {
					$line_arr = [];
					$line_arr['attribute:id'] = $line_arr['void:object_id'] = $object_id;
					$line_arr['node:object_name'] = $object_name;

					$params = $_GET;
					unset($params['path']);
					unset($params['p']);
					$params['fields_filter'][$name] = $object_id;
					$filter_link = '?' . http_build_query($params, '', '&amp;');

					unset($params['fields_filter'][$name]);
					$unfilter_link = '?' . http_build_query($params, '', '&amp;');

					$line_arr['attribute:filter_link'] = $filter_link;
					$line_arr['attribute:unfilter_link'] = $unfilter_link;

					if ($selected) {
						$line_arr['attribute:selected'] = 'selected';
					}

					$items[] = def_module::parseTemplate($template_item, $line_arr);

					if (++$i < $sz) {
						if ($is_tpl) {
							$items[] = $template_separator;
						}
					}
				} else {
					$items[] = "<option value=\"{$object_id}\" {$selected}>{$object_name}</option>";
				}
			}

			$block_arr['attribute:unfilter_link'] = $unfilter_link;
			$block_arr['attribute:name'] = $name;
			$block_arr['attribute:title'] = $title;
			$block_arr['subnodes:values'] = $block_arr['void:items'] = $items;
			$block_arr['void:selected'] = $value ? '' : 'selected';
			return def_module::parseTemplate($template, $block_arr);
		}

		public function parseSearchText(iUmiField $field, $template) {
			$block_arr = [];

			$name = $field->getName();
			$title = $field->getTitle();
			$fields_filter = getRequest('fields_filter');

			if ($fields_filter) {
				$value = (string) getArrayKey($fields_filter, $name);
			} else {
				$value = null;
			}

			$block_arr['attribute:name'] = $name;
			$block_arr['attribute:title'] = $title;
			$block_arr['value'] = self::protectStringVariable($value);

			return def_module::parseTemplate($template, $block_arr);
		}

		public function parseSearchPrice(iUmiField $field, $template) {
			$block_arr = [];

			$name = $field->getName();
			$title = $field->getTitle();

			$fields_filter = getRequest('fields_filter');
			$value = (array) getArrayKey($fields_filter, $name);

			$block_arr['attribute:name'] = $name;
			$block_arr['attribute:title'] = $title;
			$block_arr['value_from'] = self::protectStringVariable(getArrayKey($value, 0));
			$block_arr['value_to'] = self::protectStringVariable(getArrayKey($value, 1));
			return def_module::parseTemplate($template, $block_arr);
		}

		public function parseSearchInt(iUmiField $field, $template) {

			$block_arr = [];

			$name = $field->getName();
			$title = $field->getTitle();

			$fields_filter = getRequest('fields_filter');
			$value = (array) getArrayKey($fields_filter, $name);

			$block_arr['attribute:name'] = $name;
			$block_arr['attribute:title'] = $title;
			$block_arr['value_from'] = (int) getArrayKey($value, 0);
			$block_arr['value_to'] = (int) getArrayKey($value, 1);

			return def_module::parseTemplate($template, $block_arr);
		}

		public function parseSearchBoolean(iUmiField $field, $template) {
			$block_arr = [];

			$name = $field->getName();
			$title = $field->getTitle();

			$fields_filter = getRequest('fields_filter');
			$value = (array) getArrayKey($fields_filter, $name);

			$block_arr['attribute:name'] = $name;
			$block_arr['attribute:title'] = $title;
			$block_arr['checked'] = ((bool) getArrayKey($value, 0)) ? ' checked' : '';
			return def_module::parseTemplate($template, $block_arr);
		}

		public function parseSearchDate(iUmiField $field, $template) {
			$block_arr = [];

			$name = $field->getName();
			$title = $field->getTitle();
			$fields_filter = getRequest('fields_filter');

			if ($fields_filter) {
				$value = (array) getArrayKey($fields_filter, $name);
			} else {
				$value = null;
			}

			$block_arr['attribute:name'] = $name;
			$block_arr['attribute:title'] = $title;

			$from = getArrayKey($value, 0);
			$to = getArrayKey($value, 1);

			$values = [
				'from' => self::protectStringVariable($from),
				'to' => self::protectStringVariable($to),
			];
			$block_arr['value'] = $values;
			return def_module::parseTemplate($template, $block_arr);
		}

		public function parseSearchSymlink(iUmiField $field, $template, $category_id) {
			$block_arr = [];
			$items = [];

			$name = $field->getName();
			$title = $field->getTitle();

			$sel = new selector('pages');
			$sel->types('hierarchy-type');
			$sel->where('hierarchy')->page($category_id)->level(1);

			$guide_items = [];

			foreach ($sel->result() as $element) {
				$value = $element->getValue($name);

				if ($value) {
					foreach ($value as $object) {
						$guide_items[$object->id] = $object->name;
					}
				}
			}

			$fields_filter = getRequest('fields_filter');
			$value = getArrayKey($fields_filter, $name);

			$is_tpl = !def_module::isXSLTResultMode();
			$unfilter_link = '';

			foreach ($guide_items as $object_id => $object_name) {
				if (is_array($value)) {
					$selected = in_array($object_id, $value) ? 'selected' : '';
				} else {
					$selected = ($object_id == $value) ? 'selected' : '';
				}

				if ($is_tpl) {
					$items[] = "<option value=\"{$object_id}\" {$selected}>{$object_name}</option>";
				} else {
					$line_arr = [];
					$line_arr['attribute:id'] = $line_arr['void:object_id'] = $object_id;
					$line_arr['node:object_name'] = $object_name;

					$params = $_GET;
					unset($params['path']);
					unset($params['p']);
					$params['fields_filter'][$name] = $object_id;

					$filter_link = '?' . http_build_query($params, '', '&amp;');

					unset($params['fields_filter'][$name]);
					$unfilter_link = '?' . http_build_query($params, '', '&amp;');

					$line_arr['attribute:filter_link'] = $filter_link;
					$line_arr['attribute:unfilter_link'] = $unfilter_link;

					if ($selected) {
						$line_arr['attribute:selected'] = 'selected';
					}

					$items[] = def_module::parseTemplate('', $line_arr);
				}
			}

			$block_arr['attribute:unfilter_link'] = $unfilter_link;
			$block_arr['attribute:name'] = $name;
			$block_arr['attribute:title'] = $title;
			$block_arr['subnodes:values'] = $block_arr['void:items'] = $items;
			$block_arr['void:selected'] = $value ? '' : 'selected';

			return def_module::parseTemplate($template, $block_arr);
		}

		public function applyFilterName(umiSelection $sel, $value) {
			if (empty($value)) {
				return false;
			}

			if (is_array($value)) {
				foreach ($value as $key => $val) {
					if ($key == 'eq') {
						$sel->addNameFilterEquals($val);
					}

					if ($key == 'like') {
						$sel->addNameFilterLike($val);
					}
				}
				return;
			}

			$sel->addNameFilterLike($value);
		}

		public function applyFilterText(umiSelection $sel, iUmiField $field, $value) {
			$value = trim($value);
			if ($value === '') {
				return false;
			}

			if ($this->applyKeyedFilters($sel, $field, $value)) {
				return;
			}

			if (is_array($value)) {
				return;
			}

			$sel->addPropertyFilterLike($field->getId(), $value);
		}

		public function applyFilterInt(umiSelection $sel, iUmiField $field, $value) {
			if (empty($value)) {
				return false;
			}

			if ($this->applyKeyedFilters($sel, $field, $value)) {
				return;
			}

			$tmp = array_extract_values($value);
			if (empty($tmp)) {
				return false;
			}

			if (empty($value[1])) {
				if (!empty($value[0])) {
					$sel->addPropertyFilterMore($field->getId(), $value[0]);
				}
			} else {
				$sel->addPropertyFilterBetween($field->getId(), $value[0], $value[1]);
			}
		}

		public function applyFilterRelation(umiSelection $sel, iUmiField $field, $value) {
			if (empty($value)) {
				return false;
			}

			if ($this->applyKeyedFilters($sel, $field, $value)) {
				return;
			}

			$value = $this->searchRelationValues($field, $value);

			$sel->addPropertyFilterEqual($field->getId(), $value);
		}

		public function applyFilterPrice(umiSelection $sel, iUmiField $field, $value) {
			if (empty($value)) {
				return false;
			}

			if ($this->applyKeyedFilters($sel, $field, $value)) {
				return;
			}

			$tmp = array_extract_values($value);
			if (empty($tmp)) {
				return false;
			}

			if (empty($value[1])) {
				if (isset($value[0])) {
					$sel->addPropertyFilterMore($field->getId(), $value[0]);
				}
			} else {
				if ($value[0] <= $value[1]) {
					$minValue = $value[0];
					$maxValue = $value[1];
				} else {
					$minValue = $value[1];
					$maxValue = $value[0];
				}

				$sel->addPropertyFilterBetween($field->getId(), $minValue, $maxValue);
			}
		}

		public function applyFilterDate(umiSelection $sel, iUmiField $field, $value) {
			if (empty($value)) {
				return false;
			}
			$valueArray = (array) $value;

			foreach ($valueArray as $i => $val) {
				$valueArray[$i] = umiDate::getTimeStamp($val);
			}

			if ($this->applyKeyedFilters($sel, $field, $valueArray)) {
				return;
			}

			if (empty($valueArray[1])) {
				if (!empty($valueArray[0])) {
					$sel->addPropertyFilterMore($field->getId(), $valueArray[0]);
				}
			} else {
				$sel->addPropertyFilterBetween($field->getId(), $valueArray[0], $valueArray[1]);
			}
		}

		public function applyFilterFloat(umiSelection $sel, iUmiField $field, $value) {
			if (empty($value)) {
				return false;
			}

			if ($this->applyKeyedFilters($sel, $field, $value)) {
				return;
			}

			$tmp = array_extract_values($value);
			if (empty($tmp)) {
				return false;
			}

			if (empty($value[1])) {
				if (!empty($value[0])) {
					$sel->addPropertyFilterMore($field->getId(), $value[0]);
				}
			} else {
				$sel->addPropertyFilterBetween($field->getId(), $value[0], $value[1]);
			}
		}

		public function applyFilterBoolean(umiSelection $sel, iUmiField $field, $value) {
			if (empty($value)) {
				return false;
			}

			if ($this->applyKeyedFilters($sel, $field, $value)) {
				return;
			}

			if ($value) {
				$sel->addPropertyFilterEqual($field->getId(), $value);
			}
		}

		public static function protectStringVariable($stringVariable = '') {
			$stringVariable = htmlspecialchars($stringVariable);
			return $stringVariable;
		}

		public function applyKeyedFilters(umiSelection $sel, iUmiField $field, $values) {
			if (!is_array($values)) {
				return false;
			}

			foreach ($values as $key => $value) {
				if (is_numeric($key) || $value === '') {
					return false;
				}

				$dataType = $field->getFieldType()->getDataType();

				switch ($key) {
					case 'eq': {
						if (is_array($value)) {
							foreach ($value as $v) {
								$this->applyKeyedFilters($sel, $field, [$key => $v]);
							}
							break;
						}

						$value = $this->searchRelationValues($field, $value);
						if ($dataType == 'date') {
							$value = strtotime(date('Y-m-d', $value));
							$sel->addPropertyFilterBetween($field->getId(), $value, $value + 3600 * 24);
							break;
						}

						if ($dataType == 'file' || $dataType == 'img_file' || $dataType == 'swf_file') {
							if ($value > 0) {
								$sel->addPropertyFilterIsNotNull($field->getId());
							} else {
								$sel->addPropertyFilterIsNull($field->getId());
							}
						} else {
							$sel->addPropertyFilterEqual($field->getId(), $value);
						}
						break;
					}

					case 'ne': {
						$sel->addPropertyFilterNotEqual($field->getId(), $value);
						break;
					}

					case 'lt': {
						$sel->addPropertyFilterLess($field->getId(), $value);
						break;
					}

					case 'gt': {
						$sel->addPropertyFilterMore($field->getId(), $value);
						break;
					}

					case 'like': {
						$value = $this->searchRelationValues($field, $value);

						if (is_array($value)) {
							foreach ($value as $val) {
								if ($val) {
									$sel->addPropertyFilterLike($field->getId(), $val);
								}
							}
						} else {
							$sel->addPropertyFilterLike($field->getId(), $value);
						}
						break;
					}

					default: {
						return false;
					}
				}
			}
			return true;
		}

		public function searchRelationValues($field, $value) {
			if (is_array($value)) {
				$result = [];
				foreach ($value as $sval) {
					$result[] = $this->searchRelationValues($field, $sval);
				}
				return $result;
			}

			$guideId = $field->getGuideId();

			if ($guideId) {
				if (is_numeric($value)) {
					return $value;
				}

				$sel = new umiSelection;
				$sel->addObjectType($guideId);
				$sel->searchText($value);
				$result = umiSelectionsParser::runSelection($sel);
				return umiCount($result) ? $result : [-1];
			}

			return $value;
		}

	}
