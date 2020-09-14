/** Extend eip.editor for cloud controller */
(function(){


	uAdmin('getFilemanagerFooter', function (filemanager) {

		var footer = "";

		if (filemanager == 'elfinder') {
			footer = '<div id="watermark_wrapper">';
			footer += '<label for="remember_last_folder">';
			footer += getLabel('js-remember-last-dir');
			footer += '</label><input type="checkbox" name="remember_last_folder" id="remember_last_folder"'
			if (jQuery.cookie('remember_last_folder') !== 'null') {
				footer += 'checked="checked"';
			}
			footer +='/></div>';
		};

		return footer;

	}, 'eip');


	uAdmin('.pLoaderFactory', function (extend) {

		function pLoaderFactory () {
			this.init();
		};

		pLoaderFactory.prototype.init = function () {

			if (!uAdmin.eip) {
				uAdmin.onLoad('eip', this.init);
				return;
			}

			var eip = uAdmin.eip;

			jQuery('*[umi\\:photo-type-id], *[umi\\:album-type-id]').each(function () {
				var oPictureLoader = new pLoader(jQuery(this));
				oPictureLoader.init();
			});

			eip.bind('Enable', function (type) {
				jQuery(".pLoader").removeClass('hidden');
			});

			eip.bind('Disable', function (type) {
				jQuery(".pLoader").addClass('hidden');
			});

		};

		var pLoader = function (album) {

			var that = this,
				elementId = jQuery(album).attr('umi:element-id'),
				photoTypeId = jQuery(album).attr('umi:photo-type-id'),
				albumTypeId = jQuery(album).attr('umi:album-type-id'),
				tpl = jQuery('li[umi\\:region="row"]:not(.blank_item):last', album),
				phototpl = jQuery('li.photo.blank_item', album),
				albumtpl = jQuery('li.photo_album.blank_item', album),
				node,
				only;

			this.initView = function () {
				node = '<li class="pLoader hidden-text no-style"><div class="pLoader-title">';
				if (albumTypeId) {
					node += '<p class="pLoader-empty-album-title">' + getLabel('js-empty-photo-album') + '</p>';
				} else {
					node += '<p class="pLoader-add-photos-title">' + getLabel('js-upload-some-photos') + '</p>';
				}
				node += '</div>\
						<span class="pLoader-loading">\
							' + getLabel('js-created') + '<span class="pLoader-done" />\
							' + getLabel('js-out-of') + '<span class="pLoader-total" />.\
						</span>\
						<div class="pLoader-loading">' + getLabel('js-cant-touch-this') +'</div>\
						<div class="pLoader-none">' + getLabel('js-no-photos-selected') +'</div>\
						<span class="pLoader-add add-photo">' + getLabel('js-add-photos') + '</span>\
						<span class="pLoader-add add-album">' + getLabel('js-add-album') + '</span>\
					</li>';
				node = jQuery(node);
				node.addClass(window.uAdmin.eip.enabled ? 'not_hidden' : 'hidden');
				album.prepend(node);
			};

			this.switchStateTo = function (state) {
				switch (state) {
					case 'initial':
						jQuery('.pLoader-title, .pLoader-empty-album-title, .pLoader-add', node).show();
						jQuery('.pLoader-none, .pLoader-add-photos-title, .pLoader-loading', node).hide();
						break;
					case 'none':
						if (only === 'photo') { that.switchStateTo('initial-onlyphoto'); }
						if (only === 'album') { that.switchStateTo('initial-onlyalbum'); }
						jQuery('.pLoader-none', node).show();
						break;
					case 'loading':
						jQuery('.pLoader-loading', node).show();
						jQuery('.pLoader-title, .pLoader-add, .pLoader-none', node).hide();
						break;
					case 'initial-onlyphoto':
						that.switchStateTo('initial');
						only = 'photo';
						jQuery('.pLoader-add-photos-title', node).show();
						jQuery('.add-album, .pLoader-empty-album-title, .pLoader-title', node).hide();
						break;
					case 'initial-onlyalbum':
						that.switchStateTo('initial');
						only = 'album';
						jQuery('.add-photo, .pLoader-title', node).hide();
						break;
				}
			};

			this.drawNewNode = function (original, elementId, link, url) {
				var newNode = original.clone(true, true);

				newNode.attr('umi:element-id', elementId)
					.removeClass('blank_item');
				jQuery('*[umi\\:element-id]', newNode).attr('umi:element-id', elementId);

				jQuery('*[umi\\:field-name="photo"], *[umi\\:field-name="header_pic"]', newNode).each(function(){
					jQuery(this)
						.attr('src', url ||  jQuery(this).attr('umi:empty'))
						.parents("a", newNode).attr('href', link || '');
				});

				jQuery('*[umi\\:field-name="name"]', newNode).attr('href', link || '').text('');

				node.after(newNode);

				uAdmin.eip.highlightNode(jQuery('*[umi\\:field-name="name"]' ,newNode)[0]);
			};

			this.openElFinder = function () {
				var folder = './images/cms/data/',
					filename = '',
					qs = 'folder=' + folder + '&image=1&multiple=1&imagesOnly=1&noTumbs=1';
				jQuery.ajax({
					url: "/admin/filemanager/get_filemanager_info/",
					data: "folder=" + folder,
					dataType: 'json',
					complete: function (data) {
						data = eval('(' + data.responseText + ')');
						var folder_hash = data.folder_hash,
							file_hash = data.file_hash,
							lang = data.lang;
						qs += '&lang=' + lang + '&file_hash=' + file_hash + '&folder_hash=' + folder_hash;
						jQuery.openPopupLayer({
							name: "Filemanager",
							title: getLabel('js-file-manager'),
							width: 1200,
							height: 600,
							url: "/styles/common/other/elfinder/umifilebrowser.html?" + qs,
							afterClose: that.addPhotos
						});
						jQuery('#popupLayer_Filemanager .popupBody').append(uAdmin.eip.getFilemanagerFooter(data.filemanager));
					}
				});
			};

			this.addPhotos = function (srcs) {
				if (!srcs || !srcs.length) {
					that.switchStateTo('none');
					return false;
				}
				var total = jQuery('.pLoader-total', node),
					done = jQuery('.pLoader-done', node),
					uri = '/admin/content/eip_quick_add/' + elementId + '.xml?type-id=' + photoTypeId + '&force-hierarchy=1';
				that.switchStateTo('loading');
				total.text(srcs.length);
				done.text('0');
				(function addOnePhoto(i) {
					//добавляем страницу
					jQuery.get(uri, function (data) {
						var newElementId = jQuery('data', data).attr('element-id');
						if (!newElementId || jQuery('data status', data).text() !== 'ok') {
							uAdmin.eip.message(getLabel('js-edcell-get-error'));
							return;
						}
						//добавляем урл
						jQuery.post("/content/editValue/save.xml?qt=" + (new Date()).getTime(), {
							'element-id': newElementId,
							'field-name': 'photo',
							'object-id': '',
							'value': typeof srcs[i] == 'string' ? srcs[i] : srcs[i].url
						}, function () {
							done.text(srcs.length - i);
							var mytpl = tpl.length ? tpl : (phototpl.length ? phototpl : null);
							if (mytpl) {
								jQuery.get('/upage/' + newElementId, function (data) {
									var	link = jQuery('page', data).attr('link'),
										url = jQuery('property[name="photo"] value', data).text();
									that.drawNewNode(mytpl, newElementId, link, url);
									if (i > 0) {
										addOnePhoto(--i);
									} else {
										that.finish('photo', false);
									}
								});
							} else {
								if (i > 0) {
									addOnePhoto(--i);
								} else {
									that.finish('photo', true);
								}
							}
						});
					});
				}(srcs.length - 1));
			};

			this.addAlbum = function () {
				var uri = '/admin/content/eip_quick_add/' + elementId + '.json?type-id=' + albumTypeId + '&force-hierarchy=1';
				jQuery.get(uri, function (result) {
					var newElementId = result.data['element-id'];
					var mytpl = tpl.length ? tpl : (albumtpl.length ? albumtpl : null);
					jQuery.get('/upage/'+newElementId+'.json', function(result){
						if (mytpl) {
							var link = '';
							if (result && result.page && result.page.link) {
								link = result.page.link;
							}
							that.drawNewNode(mytpl, newElementId, link, '');
							that.finish('album', false);
						} else {
							that.finish('album', true);
						}
					}, 'json');
				},'json');
			};

			this.init = function () {
				that.initView();
				if (photoTypeId && albumTypeId) {
					only = '';
					that.switchStateTo('initial');
				}
				if (photoTypeId && !albumTypeId) {
					only = 'photo';
					that.switchStateTo('initial-onlyphoto');
				}
				if (!photoTypeId && albumTypeId) {
					only = 'album';
					that.switchStateTo('initial-onlyalbum');
				}
				jQuery('.add-photo', node).bind('click', that.openElFinder);
				jQuery('.add-album', node).bind('click', that.addAlbum);
			};

			this.finish = function (what, reload) {
				switch (what) {
					case 'photo':
						that.switchStateTo('initial-onlyphoto');
						break;
					case 'album':
						that.switchStateTo('initial-onlyalbum');
						break;
					default:
						that.switchStateTo('initial');
				}

				if (reload) {
					var queue = window.uAdmin.eip.queue;
					if (queue && queue.isModified()) {
						queue.submit();
					} else {
						(window || document).location.reload(true);
					}
				}
			};

		};

		return extend(pLoaderFactory, this);

	}, 'eip');


	uAdmin('.optionedFieldsCollection', function () {

		//var optFields = new optionedFieldsCollection(jQuery('[umi\\:field-type="optioned"]'));


		var _isFunction = function (obj) {
			return typeof (obj) === 'function';
		};

		var self = this,
			collection = this,
			n = 0,
			items = [],
			itemsHash = {},
			elementsSelector = '[umi\\:field-type="optioned"]';

		/**
		 * Apply function on all items
		 * @fName string
		 * @fArgs array | undefined
		 */
		this.applyToAllFields = function (fName, fArgs) {
			var i = 0,
				res = [];
			if (!fName) { return false; }
			fArgs = fArgs || [];
			while (i < n) {
				res.push(!_isFunction(items[i][fName]) || items[i][fName].apply(this, fArgs));
				i += 1;
			}
			return res;
		};

		/**
		 * Apply function on all nodes of items
		 * @fName string
		 * @fArgs array | undefined
		 */
		this.applyToAllNodes = function (fName, fArgs) {
			var i = 0,
				res = [];
			if (!fName) { return false; }
			fArgs = fArgs || [];
			while (i < n) {
				res.push(!_isFunction(items[i].getNode()[fName]) || items[i].getNode()[fName].apply(items[i].getNode(), fArgs));
				i += 1;
			}
			return res;
		};

		/** Add item to collection */
		this.addItem = function (node) {
			var newItem = new EditOptioned(node);
			if (uAdmin.eip.enabled) {
				newItem.getNode().addClass('field_editable');
			}
			items.push(newItem);
			itemsHash[newItem.hash()] = newItem;
			n += 1;
		};

		/** Update all items originalValue to currentValue */
		this.updateAll = function (fields) {
			var i = 0, n,
				field, item, hash;
			n = fields.total;
			while (i < n) {
				field = fields[i];
				hash = field['element-id'] + '_' + field['field-id'];
				item = itemsHash[hash];
				item.updateData(field.value || {}, field.guide || {});
				++i;
			}
		};

		/** Push changes to server */
		this.submit = function (callback) {
			var uri = '/udata/content/saveOptioned.json',
				query = collection.applyToAllFields('prepareDataForSubmit');
			$.post(uri, {data: query}, function (data) {
				self.submitCallback(data);
				if (_isFunction(callback)) {
					callback();
				}
			}, 'json');
		};

		this.submitCallback = function (data) {
			collection.applyToAllNodes('removeClass', ['field_modified u-eip-modified']);
			collection.updateAll(data);
		};

		/** Cancel all changes, show original markup */
		this.restore = function () {
			self.applyToAllFields('finishEditing', [true]);
		};

		/** Finish editing on all items */
		this.finishAll = function () {
			self.applyToAllFields('finishEditing');
		};

		/** Check for any changes in items values */
		this.anyChanges = function () {
			return $.inArray(true, self.applyToAllFields('hadChanged')) !== -1;
		};

		/** Create collection, bind events */
		this.init = function () {

			var nodes = jQuery(elementsSelector);

			nodes.each(function () {
				self.addItem($(this));
			});

			uAdmin.eip.bind('Enable', function (type) {
				if (type == 'after') {
					self.applyToAllNodes('addClass', ['field_editable']);
				}
			});

			uAdmin.eip.bind('Disable', function (type) {
				if (type == 'after') {
					self.applyToAllNodes('removeClass', ['field_editable']);
					self.finishAll();
				};
			});
		};

		/**
		 * Конструктор редактируемного поля типа optioned
		 * @node jQuery object
		 */
		function EditOptioned(node) {
			var self = this,
				elementId, fieldId, fieldName, guideId,
				props, originalProps,
				guide,
				guideHashMap,
				editNode,
				active = false,
				iWasClicked = false,
				hasData = false,
				selectTxt = 'Выберите значение',
				emptyTxt;

			/** Helper to hard copy object or array */
			var _hardCopy = function (obj) {
				return	jQuery.isArray(obj) ? jQuery.extend(true, [], obj) : jQuery.extend(true, {}, obj);
			};

			/** node getter */
			this.getNode = function () {
				return node;
			};

			/** props getter */
			this.getProps = function () {
				return props;
			};

			/** active getter */
			this.isActive = function () {
				return active;
			};

			/** Returns hash of the field, it's implied that tuple (elementId, fieldId) is unique */
			this.hash = function () {
				return elementId + '_' + fieldId;
			}
			/** Remove all nodes that don't have 'persisit' class */
			this.clean = function () {
				$('> *:not(.persist)', node).remove();
			};

			/**
			 * Get guide and value of optioned property in one request
			 * @callback function
			 */
			this.getData = function (callback) {
				var uri = '/udata/content/getOptionedAndGuide?element-id=' + elementId + '&property-id=' + fieldId + '&property-name=' + fieldName;

				if (hasData && _isFunction(callback)) {
					callback();
					return;
				}

				$.get(uri, function (data) {
					guide = [];
					guideHashMap = {};
					guideId = $('guide', data).attr('id');

					$('guide item', data).each(function () {
						var me = $(this),
							new_id = $('id', me).text(),
							new_name = $('name', me).text();
						guide.push({
							'id': new_id,
							'name': new_name
						});
						guideHashMap[new_id] = new_name;
					});

					props = [];
					$('optioned value', data).each(function () {
						var me = $(this);
						props.push({
							'rel': $('rel', me).text(),
							'float': $('float', me).text() || 0
						});
					});
					originalProps = _hardCopy(props);

					hasData = true;

					if (typeof callback === 'function') {
						callback();
					}
				});

			};

			/**
			 * Generate html text that represents guide
			 * @selected boolean
			 */
			this.makeSelectFromGuide = function (selected) {
				var txt = '<select class="opt_prop_rel_select">',
					i;

				for (i = 0; i < guide.length; i++) {
					txt += '<option value="' + guide[i].id + '"';
					if (guide[i].id == selected) { txt += ' selected="selected" '; }
					txt += '>' + guide[i].name + '</option>';
				}

				txt += '</select>';

				txt += '<div class="add_item_to_guide_wrapper">' +
					'<input type="text" class="add_item_to_guide_field" placeholder="Новое значение"/>' +
					'<div class="add_item_to_guide_button"></div>' +
					'</div>';

				return txt;
			};

			this.makePropBlock = function (rel) {
				var txt =
					'<div class="opt_prop_rel with_val" data-rel="' + rel + '">' +
						'<span class="opt_prop_rel_val">' + guideHashMap[rel] +
						'</span></div>';

				return txt;
			};

			/**
			 * Create DOM node that represents single property
			 * @prop object with fields:
			 *		@rel int
			 *		@float float
			 *		@toDelete boolean | undefined
			 */
			this.makePropRowNode = function (prop) {
				var opt = this;
				var newNode = $(
					'<tr class="opt_prop_edit"><td>' + self.makePropBlock(prop.rel) + '</td>' +
						'<td><input type="text" class="prop_float" value="' + prop.float + '" /></td>' +
						'<td><span class="prop_delete">&#215;</span></td></tr>'
				);

				if (prop.toDelete) {
					newNode.addClass('opt-prop-deleted');
				}

				$('.prop_delete', newNode).bind('click', function () {
					newNode.toggleClass('opt-prop-deleted');
				});

				return newNode;
			};

			/** Return jQuery node with events to add new row */
			this.makeAddRowNode = function () {
				var new_node = $(
					'<tr class="opt_props_add_row">' +
						'<td><div class="opt_prop_add with_val">' + selectTxt + '</div></td>' +
						'<td><input type="text" class="prop_float" placeholder="Модификатор цены" /></td>' +
						'<td><span class="prop_add prop_add_disabled">&#43;</span></td></tr>'
				);

				$('.opt_prop_add', new_node).click(function () {
					new_node.find('.prop_add').removeClass('prop_add_disabled');
				});

				$('.prop_add', new_node).bind('click', function () {
					var me = $(this).parent().parent(),
						val = me.find('.opt_prop_add select').val() ||
							me.find('.opt_prop_add').text(),
						new_prop;
					if (!val || val === selectTxt) { return false; }

					if (!guideHashMap[val]) {
						val = '_' + val;
					}

					new_prop = {
						'rel': val,
						'float': parseFloat($('.prop_float', me).val()) || 0
					};
					$('tr:last', editNode).before(self.makePropRowNode(new_prop));
					//reset to default selection
					self.cleanAllSelects();
					$('.opt_prop_add', me).html(selectTxt);
					$('.prop_float', me).val('');
					$('.prop_add', me).addClass('prop_add_disabled');
				});

				return new_node;
			};


			/** Helper to count not deleted values from optioned field, used to check if it's empty */
			this.countNotDeletedValues = function () {
				var res = 0,
					i = props.length - 1;
				while (i >= 0) {
					if (!props[i].toDelete) {
						res += 1;
					}
					i -= 1;
				}
				return res;
			};

			/** Show Original Markup */
			this.showOriginalMarkup = function () {
				var i, newNode;

				if (!hasData) { return; }

				self.clean();

				if (!props.length) {
					node.append('<div class="u-eip-empty-field"> ' + emptyTxt + '</div>');
				}

				for (i = 0; i < props.length; i++) {
					if (props[i].rel && !props[i].toDelete) {
						newNode = $('<div class="opt_prop"><input type="radio" name="' + fieldName + '" value="' + props[i].float + '" id="' + props[i].rel + '"/><span class="opt_prop_rel">' + guideHashMap[props[i].rel] + '</span></div>');
						node.append(newNode);
					}
				}

				if (self.countNotDeletedValues()) {
					node.removeClass('not_hidden hidden');
				} else {
					node.addClass('not_hidden');
				}
			};

			/** Hide unnecessary content and draw edit control */
			this.initEditing = function () {
				var i, newNode;

				self.clean();

				editNode = $('<table class="opt_props_edit_block" valign="top"/>');
				for (i = 0; i < props.length; i++) {
					editNode.append(self.makePropRowNode(props[i]));
				}
				editNode.append(self.makeAddRowNode());
				node.append(editNode);

				editNode.sortable({
					items: '.opt_prop_edit',
					axis: 'y',
					cursor: 'crosshair',
					cancel: 'td > *'
				});

				node.addClass('editting').removeClass('u-eip-modified');
				active = true;

				// setting initial state
				if (self.revision.current == -1) {
					self.revision.add(self);
				};

			};

			this.cleanAllSelects = function () {
				if (!editNode) { return ; }

				editNode.find('.opt_prop_rel, .opt_prop_add').each(function () {
					var me = $(this);
					if (!me.hasClass('with_val')) {
						var relId = me.find('select').val();
						me.addClass('with_val')
							.attr('data-rel', relId);
						if (me.hasClass('opt_prop_rel')) {
							me.html('<span class="opt_prop_rel_val">' + guideHashMap[relId] + '</span>');
						} else {
							me.html(guideHashMap[relId] || selectTxt);
						}
					}
				});

			};

			/** Agregate data from user input */
			this.getDataFromNodes = function () {
				var res = [];
				$('.opt_prop_edit', editNode).each(function () {
					var me = $(this);
					res.push({
						'int': 1,
						'float': parseFloat($('.prop_float', me).val()) || 0,
						'rel': $('.opt_prop_rel_select', me).val() || $('.opt_prop_rel', me).attr('data-rel'),
						'toDelete': me.hasClass('opt-prop-deleted')
					});
				});
				return res;
			};

			/**
			 * Finish editing
			 * @discardChanges boolean | undefined
			 */
			this.finishEditing = function (discardChanges) {
				if (!active) { return false; }
				active = false;
				props = discardChanges ? originalProps : self.getDataFromNodes();
				self.showOriginalMarkup();
				node.removeClass('editting');
				if (self.hadChanged()) {
					node.addClass('field_modified');
					self.revision.add(self);
				} else {
					node.removeClass('field_modified');
				}
				if (this.revision.current > 0) {
					node.addClass('u-eip-modified');
				}
			};

			/** Save element to backend */
			this.save = function () {
				var uri = '/udata/content/saveOptioned.json';
				$.post(uri, {data: [this.prepareDataForSubmit()]}, function (data) {
					collection.submitCallback(data);
				}, 'json');
			};

			/** Switch to previous revision */
			this.back = function () {
				this.revision.back();
				var newState = this.revision.getCurrent();
				node.html(newState.html);
				props = newState.props;
				this.showOriginalMarkup();
				node.removeClass('editing');
				if (!self.hadChanged()) {
					node.removeClass('field_modified');
				};
			};

			/** Switch to next revision */
			this.forward = function () {
				this.revision.forward();
				var newState = this.revision.getCurrent();
				node.html(newState.html);
				props = newState.props;
				this.showOriginalMarkup();
				node.removeClass('editing');
				if (self.hadChanged()) {
					node.addClass('field_modified');
				};
			};

			/** Check if any changes were made */
			this.hadChanged = function () {
				if (!hasData) { return false; }
				if (props.length !== originalProps.length) { return true; }
				var i;
				for (i = props.length - 1; i >= 0; i--) {
					if (props[i].toDelete) { return true; }
					if (props[i].rel != originalProps[i].rel) { return true; }
					if (props[i].float != originalProps[i].float) { return true; }
				}
				return false;
			};

			/** Submit changes to server */
			this.prepareDataForSubmit = function () {
				var newProps = [],
					i;
				if (!self.hadChanged()) { return false; }
				for (i = 0; i < props.length; i++) {
					if (!props[i].toDelete) {
						delete props[i].toDelete;
						newProps.push(props[i]);
					}
				}
				return {
					'element-id': elementId,
					'field-id'	: fieldId,
					'field-name': fieldName,
					'value'		: newProps
				};
			};

			/** Copy props to originalProps */
			this.updateData = function (data, newGuide) {
				var i;

				if (!hasData) { return false; }

				originalProps = [];
				for (i in data) {
					if (i && data[i]) {
						originalProps.push(_hardCopy(data[i]));
					}
				}
				props = _hardCopy(originalProps);

				guide = [];
				guideHashMap = {};

				for (i in newGuide) {

					guide.push({
						'id': i,
						'name': newGuide[i]
					});

					guideHashMap[i] = newGuide[i];
				}

				self.showOriginalMarkup();
			};

			/** Init control on node, bind events */
			this.init = function () {
				active = false;

				elementId = node.attr('umi:element-id');
				fieldId = node.attr('umi:fieldId');
				this.fieldId = fieldId;
				fieldName = node.attr('umi:fieldName');

				emptyTxt = node.attr('umi:empty') || 'Добавьте свойства';

				if (!elementId || !fieldId || !fieldName) { return false; }

				if (!node.find('.opt_prop').length) {
					node.append('<div class="u-eip-empty-field"> ' + emptyTxt + '</div>');
				}

				node.bind('click', function (e) {
					if (!uAdmin.eip.enabled) { return; }
					if (!active) {
						active = true;
						self.getData(self.initEditing);
					}
					iWasClicked = true;

					if (!hasData) { return; }

					var target = $(e.target);
					if (target.closest('.opt_prop_rel, .opt_prop_add').length) {
						var clickedRel = target.closest('.opt_prop_rel, .opt_prop_add'),
							relId = clickedRel.attr('data-rel');

						if (clickedRel.hasClass('with_val')) {
							self.cleanAllSelects();
							clickedRel.removeClass('with_val');
							clickedRel.html(self.makeSelectFromGuide(relId));


						}
					}

					if (target.hasClass('add_item_to_guide_button')) {
						var newGuideItem = target.prev().val(),
							searchFlag = true;

						if (newGuideItem !== '') {
							$.each(guide, function (index, val) {
								if (val.name === newGuideItem) {
									searchFlag = false;
									return false;
								}
							})

							if (searchFlag) {
								guide.push({
									'id': '_' + newGuideItem,
									'name': newGuideItem
								});

								guideHashMap['_' + newGuideItem] = newGuideItem;
								target.parent().prev().append('<option value="_' + newGuideItem + '" selected="selected">' + newGuideItem + '</option>');
								self.cleanAllSelects();
							}
						}
					}
				});

				$('html').bind('click', function () {
					if (iWasClicked) {
						iWasClicked = false;
						return;
					}
					if (active) { self.finishEditing(); }
				});
			};

			self.init();
		};

		/**
		 * Optioned versions control
		 * @type {Array}
		 */
		EditOptioned.prototype.revision = [];

		jQuery.extend(EditOptioned.prototype.revision, new RevisionMixin());

		/**
		 * Versions control mixin
		 * @constructor
		 */
		function RevisionMixin () {

			/**
			 * current revision number
			 * @type {Number}
			 */
			this.current = -1;

			/**
			 * get last revision number
			 * @return {Number}
			 */
			this.getLastId = function () {
				var max = 0;
				for (var i = 0; i < this.length; i++) {
					if (i > max) {
						max = i;
					};
				};
				return max;
			};

			/**
			 * get next revision number
			 * @return {Number}
			 */
			this.getNextId = function () {
				var next = this.current,
					last = this.getLastId();
				if (next < last)
					do {
						next++;
					} while (!this[next] && next != last);
				return next;
			};

			/**
			 * get previous revision number
			 * @return {Number}
			 */
			this.getPreviousId = function () {
				var prev = this.current;
				if (prev > 0)
					do {
						prev--;
					} while (!this[prev] && prev > 0);
				return prev;
			};

			/**
			 * get revision contents by number
			 * @param revNumber
			 * @return {*}
			 */
			this.get = function (revNumber) {
				return this[revNumber];
			};

			/**
			 * get current revision contents
			 * @return {*}
			 */
			this.getCurrent = function () {
				return this.get(this.current);
			};

			/**
			 * add new revision
			 * @param optioned
			 * @return {Number}
			 */
			this.add = function (optioned) {
				this.truncateToCurrent();
				this.current++;
				this[this.current] = {
					html: optioned.getNode().html(),
					props: optioned.getProps()
				};
				if (this.current > 0) {
					this.pushToEipQueue(optioned);
				}
				return this.current;
			};

			this.pushToEipQueue = function (optioned) {
				uAdmin.eip.queue.add({
					custom: true,
					id: optioned.fieldId + this.current,
					node: optioned.getNode().get(0),
					target: optioned
				});
			}

			/**
			 * remove revision by number
			 * @param revNumber
			 */
			var remove = function (revNumber) {
				if (!revNumber) revNumber = this.current;
				delete this[revNumber];
				if (revNumber == this.current) {
					this.current = this.getPreviousId();
				};
			};

			/** remove last revision */
			this.removeLast = function () {
				remove(this.current);
				uAdmin.eip.queue.back();
			};

			/**
			 * truncate revisions collection to given revision number
			 * @param revNumber
			 */
			this.truncate = function (revNumber) {
				var needToRenewCurrent = false;
				for (var i = 0; i < this.length; i++) {
					if (i > revNumber) {
						delete this[i];
						if (i == this.current) {
							needToRenewCurrent = true;
						};
					};
				};
				if (needToRenewCurrent) {
					this.current = this.getLastId();
				};
			};

			/** truncate revisions collection to current revision */
			this.truncateToCurrent = function () {
				this.truncate(this.current);
			};

			/** switch to previous revision */
			this.back = function () {
				this.current = this.getPreviousId();
			};

			/**
			 * switch to next revision if exists
			 * @param node
			 */
			this.forward = function (node) {
				this.current = this.getNextId();
			}
		}

	}, 'eip');

	uAdmin.onLoad('eip', function () {

		uAdmin.eip.editor.draw.file = function(self, image) {
			var folder = './images/cms/data/',
				fileName = '', file, data, params;

			self.finish = function (apply) {
				if (apply) {
					if (self.info.node.tagName == 'IMG') {
						self.info.node.src = self.info.new_value.src;
					}
					else self.info.node.style.backgroundImage = 'url(' + self.info.new_value.src + ')';
					self.commit();
				}
				self.cleanup();
			};

			if (self.info.old_value) {
				if (self.info.old_value.src == undefined) {
					self.info.old_value = {
						src: self.info.old_value
					}
				}
				fileName = self.info.old_value.src.split(/\//g).pop();
				folder = '.' + self.info.old_value.src.substr(0, self.info.old_value.src.length - fileName.length - 1);
			}

			if (self.files && self.files.length) {
				file = self.files[0];

				file.folder = folder;
				if (self.info.old_value) {
					file.file = self.info.old_value.src;
				}
				if (image) {
					file.image = 1;
				}

				data = jQuery.ajax({
					url: "/admin/data/uploadfile/",
					async : false,
					data : file,
					type : 'POST',
					dataType : 'json'
				});

				data = JSON.parse(data.responseText);

				if (data.file.path) {
					self.new_value = data.file.path;
					self.finish(true);
				}
				else self.finish();
			}
			else {
				params = {
					folder : folder,
					file   : self.info.old_value ? self.info.old_value.src : ''
				};
				data = jQuery.ajax({
					url: "/admin/filemanager/get_filemanager_info/",
					async : false,
					data : params,
					type : 'POST',
					dataType : 'json'
				});
				data = JSON.parse(data.responseText);

				var qs = 'folder=' + folder;
				if (self.info.old_value) qs += '&file=' + self.info.old_value.src;
				if (image) qs += '&image=1';

				var fm = {
					flash :  {
						height : 460,
						url    : "/styles/common/other/filebrowser/umifilebrowser.html?" + qs
					},
					elfinder : {
						height : 600,
						url    : "/styles/common/other/elfinder/umifilebrowser.html?" + qs + '&lang=' + data.lang + '&file_hash=' + data.file_hash + '&folder_hash=' + data.folder_hash
					}
				};

				jQuery.openPopupLayer({
					name   : "Filemanager",
					title  : getLabel('js-file-manager'),
					width  : 1200,
					height : fm[data.filemanager].height,
					url    : fm[data.filemanager].url,
					afterClose : function (value) {
						if (value) {
							if (typeof value == 'object') value = value[0];
							self.info.new_value = value ? {src:value.toString()} : '';
							self.finish(true);
						}
						else self.finish();
					}
				});
				jQuery('#popupLayer_Filemanager .popupBody').append(uAdmin.eip.getFilemanagerFooter(data.filemanager));
			}
			return self;

		};


		uAdmin.eip.editor.draw.text = function(self, allowHTMLTags) {

			var node = jQuery(self.info.node), source = node.html();

			if (allowHTMLTags) self.info.old_value = self.info.old_value.replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"');
			node.html(self.info.old_value || '&nbsp;');
			node.attr('contentEditable', true);
			node.blur().focus();

			self.finish = function (apply) {
				self.finish = function () {};
				jQuery(document).unbind('keyup');
				//jQuery(document).unbind('keydown');
				jQuery(document).unbind('click');

				node.attr('contentEditable', false);
				jQuery('.u-eip-sortable').sortable('enable');

				if (apply) {
					if (!allowHTMLTags && self.info.field_type != 'wysiwyg') {
						var html = node.html();
						if (html.match(/\s<br>$/g)) html = html.replace(/<br>$/g, '');
						var originalHtml = html;
						html = html.replace(/<!--[\w\W\n]*?-->/mig, '');
						html = html.replace(/<style[^>]*>[\w\W\n]*?<\/style>/mig, '');
						html = html.replace(/<([^>]+)>/mg, '');
						html = html.replace(/(\t|\n)/gi, " ");
						html = html.replace(/[\s]{2,}/gi, " ");
						if (jQuery.browser.safari) {
							html = html.replace(/\bVersion:\d+\.\d+\s+StartHTML:\d+\s+EndHTML:\d+\s+StartFragment:\d+\s+EndFragment:\d+\s*\b/gi, "");
						}
						if (html != originalHtml) node.html(html);
					}
					self.info.new_value = node.html();

					if (self.info.new_value == ' ' || self.info.new_value == '&nbsp;' || self.info.new_value == '<p>&nbsp;</p>') {
						self.info.new_value = '';
						node.html(self.info.new_value);
					}

					if (self.info.field_type != 'wysiwyg' && self.info.field_type != 'text') {
						self.info.new_value = jQuery.trim(self.info.new_value);
						if (self.info.new_value.substr(-4, 4) == '<br>') {
							self.info.new_value = self.info.new_value.substr(0, self.info.new_value.length -4);
						}
					}
					else {
						self.info.new_value = self.info.new_value.replace(/%[A-z0-9_]+(?:%20)+[A-z0-9_]+%28[A-z0-9%]*%29%/gi, unescape);
						self.info.new_value = self.info.new_value.replace(/\/\/\s\]\]>/gi, '// ]] >');
					}

					switch(self.info.field_type) {
						case "int":
						case "float":
						case "price":
						case "counter":
							self.info.new_value = parseFloat(self.info.new_value);
							break;
					}

					self.commit();
				}
				else node.html(source);
				self.cleanup();
			};

			self.bindFinishEvent();

			var prevWidth = node.width(),
				prevHeight = node.height(),
				timeoutId = null;

			jQuery('.u-eip-sortable').sortable('disable');
			node.focus();

			var prevLength = null;

			jQuery(document).bind('keyup', function (e) {
				if (prevWidth != node.width() || prevHeight != node.height()) {
					prevWidth = node.width();
					prevHeight = node.height();

					if (timeoutId) clearTimeout(timeoutId);
					timeoutId = setTimeout(function () {
						uAdmin.eip.normalizeBoxes();
						timeoutId = null;
					}, 1000);
				}

				if (e.keyCode == 46) {
					if (prevLength == node.html().length) {
						if (prevLength == 1) {
							node.html('');
						}
					}
				}
			}).bind('keydown', function (e) {
					if (e.keyCode == 46) {
						prevLength = node.html().length;
					}

					//Enter key - save content
					if (e.keyCode == 13 && self.info.field_type != 'wysiwyg' && self.info.field_type != 'text') {
						self.finish(true);
						return false;
					}

					//Esc key - cancel and revert original value
					if (e.keyCode == 27) {
						self.finish(false);
						return false;
					}

					return true;
				});
			return self;
		};

		uAdmin.eip.optionedFieldsCollection.init();

	});

})();
