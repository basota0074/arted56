/** Extend uEditInPlace for cloud controller */
(function (){

	function onUmiDeleteMouseOver (element) {

		var eip = uAdmin.eip;
		var info = eip.searchAttr(element);
		info.node = element;
		if(eip.enabled && jQuery(element).attr('umi:delete') && (info['type'] == 'element' || info['type'] == 'object')) {
			eip.addDeleteButton(element, info);
		} else {
			eip.dropDeleteButtons();
		}

	};

	uAdmin('initEditBoxes', function () {
		var eip = this;

		jQuery(document).on('mouseover', '.u-eip-edit-box', function() {
			eip.editBoxMouseoverHandler(this);
		});

		jQuery(document).on('mouseover', '[umi\\:delete]', function() {
			onUmiDeleteMouseOver(this);
		});

		jQuery(document).on('mouseover', '.u-eip-edit-box:not([umi\\:delete])', function() {
			eip.editBoxMouseoverHandler(this);
		});

		jQuery(document).on('mouseout', '.u-eip-edit-box-hover', function() {
			eip.editBoxMouseoutHandler(this);
		});

	}, 'eip');

	uAdmin('addDeleteButton', function (element, info) {

		var node = jQuery(element),
			eip = this;

		if(!node.hasClass('umiru-highlight-block-disable')) {
			node.addClass('u-eip-edit-box-hover');
		} else {
			return;
		}

		if(eip.deleteButtonsTimeout) clearTimeout(eip.deleteButtonsTimeout);
		eip.dropDeleteButtons();

		var deleteButton = document.createElement('div');
		jQuery(deleteButton).attr('class', 'eip-del-button');

		var deleteText = "Удалить";
		if(node.attr('umi:delete-text')) {
			deleteText = node.attr('umi:delete-text');
		}

		jQuery(deleteButton).html('<span class="eip-del-buttonx">x</span><span class="eip-del-buttontext">' + deleteText + '</span>');
		document.body.appendChild(deleteButton);
		eip.placeWith(element, deleteButton, 'right', 'middle');
		jQuery(deleteButton)
			.css('left', (parseFloat(jQuery(deleteButton).css('left').replace('px', '')) - 12) + "px")
			.bind('mouseover', function () {
				var x, y, width, height;
				var box = document.createElement('div');
				document.body.appendChild(box);
				var position = eip.nodePositionInfo(node);
				if(!position.x && !position.y) return;
				jQuery(box).attr('class', 'u-eip-del-box-highlight');
				jQuery(box).css({
					'position':		'absolute',
					'width':		position.width,
					'height':		position.height,
					'left':			position.x,
					'top':			position.y
				});
				if(eip.deleteButtonsTimeout) clearTimeout(eip.deleteButtonsTimeout);
			})
			.bind('mouseout', function () {
				jQuery('.u-eip-del-box-highlight').remove();
				eip.deleteButtonsTimeout = setTimeout(eip.dropDeleteButtons, 500);
			})
			.bind('click', function () {
				info['delete'] = true;
				eip.queue.add(info);
				eip.normalizeBoxes();
			});

	}, 'eip');


	uAdmin('unhighlight', function () {

		jQuery('.u-eip-edit-box')
			.each(function (index, node) {
				jQuery('.umiru-eip-outline-block').removeClass('umiru-eip-outline-block');
				node = jQuery(node);
				var empty = node.attr('umi:empty');
				if(empty && (node.attr('tagName') != 'IMG') && (node.html() == empty)) {
					node.html('');
				}

				node.attr('title', '');
			})
			.removeClass('u-eip-edit-box u-eip-edit-box-hover u-eip-modified u-eip-deleted u-eip-edit-box-inversed')
			.unbind('click')
			.unbind('mouseover')
			.unbind('mouseout')
			.unbind('mousedown')
			.unbind('mouseup');

		jQuery('.u-eip-add-box, .u-eip-add-button, .u-eip-del-button').remove();

		jQuery('.u-eip-sortable').sortable('destroy').removeClass('u-eip-sortable');

	}, 'eip');


	uAdmin('searchRow', function(node, parent) {
		if (parent) {
			if (node.tagName == 'BODY' || node.tagName == 'TABLE') return false;
			if (jQuery(node.parentNode).attr('umi:region') == 'row') {
				return node.parentNode;
			}
			else return this.searchRow(node.parentNode, true);
		}
		else return jQuery('*[umi\\:region]', node).filter(function(){
			var selector = '[umi\\:element-id^="new"], [umi\\:object-id^="new"]';
			return !jQuery(this).find(selector).length && !jQuery(this).is(selector)
		}).get(0);
	}, 'eip');


	uAdmin('highlightNode', function (node) {
		if (!jQuery(node).attr('umi:field-name')) return;
		var info = this.searchAttr(node);
		if (!info) return;

		var empty = this.htmlTrim(jQuery(node).attr('umi:empty'));

		if(empty && this.htmlTrim(jQuery(node).html()) == '' && (jQuery(node).attr('tagName') != 'IMG')) {
			try{
				jQuery(node).html(empty);
			} catch(e) {}
			jQuery(node).addClass('u-eip-empty-field');
		}

		jQuery(node).addClass('u-eip-edit-box');

		if (this.queue.search(info)) {
			jQuery(node).addClass('u-eip-modified');
		}

		var label = getLabel('js-panel-link-to-go');
		if (navigator.userAgent.indexOf('Mac OS') != -1) {
			label = label.replace(/Ctrl/g, 'Cmd');
		}
		jQuery(node).attr('title', label);
		jQuery(node).bind('dblclick', function () {
			return false;
		});

		jQuery(document).on('mouseenter', '.u-eip-editing', function() {
			this.title = '';
		});

		jQuery(document).on('mouseleave', '.u-eip-editing', function() {
			this.title = label;
		});

		this.markInversedBoxes(jQuery(node));

	}, 'eip');


	uAdmin('highlightListNode', function (node) {

		var self = this;
		if(!jQuery(node).attr('umi:module')) return false;

		var box = document.createElement('div');
		document.body.appendChild(box);
		node.boxNode = box;

		var position = self.nodePositionInfo(node);
		if(!position.x && !position.y) return false;

		jQuery(box).attr('class', 'u-eip-add-box');

		jQuery(node).addClass('umiru-eip-outline-block');

		jQuery(box).css({
			'position':		'absolute',
			'width':		position.width,
			'height':		position.height,
			'left':			position.x,
			'top':			position.y
		});

		if (jQuery(node).attr('umi:add-method') != 'none') {
			this.addAddButton(node, box);
		}

		if (jQuery(node).attr('umi:sortable') == 'sortable') {
			this.setNodeSortable(node, box);
		}

		return box;

	}, 'eip');


	uAdmin('addAddButton', function (node, box) {

		var button = document.createElement('div');
		node.addButtonNode = button;

		var addText = getLabel('js-panel-add');
		if(jQuery(node).attr('umi:add-text')) {
			addText = jQuery(node).attr('umi:add-text');
		}

		jQuery(button)
			.attr({
				'class': 'u-eip-add-button'
			})
			.html('<span class="u-eip-addplusbtn">+</span><span class="u-eip-addtextbutton">' + addText + '</span>')
			.hover(function () {
				jQuery(this).addClass('u-eip-add-button-hover');
			}, function () {
				jQuery(this).removeClass('u-eip-add-button-hover');
			});

		jQuery(node)
			.mouseover(function() {
				jQuery(button).addClass('u-eip-add-button-hover');
			})
			.mouseout(function() {
				jQuery(button).removeClass('u-eip-add-button-hover');
			});

		var fDim = 'bottom';
		var sDim = 'left';
		var userPos;
		if (userPos = jQuery(node).attr('umi:button-position')) {
			var arr = userPos.split(/ /);
			if(arr.length == 2) {
				fDim = arr[0];
				sDim = arr[1];
			};
		};

		this.placeWith(node, button, fDim, sDim);

		var self = this;
		jQuery(button)
			.bind('click', function () {
				self.onAddButtonMouseup(node);
			})
			.bind('mouseover', function () {
				self.onAddButtonMouseover(box);
			})
			.bind('mouseout', function () {
				self.onAddButtonMouseout(box);
			});

		document.body.appendChild(button);

	}, 'eip');


	uAdmin('onAddButtonMouseup', function (node) {
		var self = this,
			regionType = jQuery(node).attr('umi:region') || null,
			rowNode = self.searchRow(node) || null,
			elementId = parseInt(jQuery(node).attr('umi:element-id')),
			module = jQuery(node).attr('umi:module') || '',
			method = jQuery(node).attr('umi:method') || '',
			addMethod = jQuery(node).attr('umi:add-method'),
			needReload = jQuery(node).attr('umi:add-reboot') ? 'true' : 'false';

		if (rowNode && (regionType == 'list') && (addMethod != 'popup')) {
			self.inlineAddPage(node);
		}
		else {
			if (self.queue.current >= 0) {
				self.message(getLabel('js-panel-message-save-first'));
				return;
			}

			var url = '/admin/content/eip_add_page/choose/' + elementId + '/' + module + '/' + method + '/',
				sCsrfToken = uAdmin.csrf ? '?csrf=' + uAdmin.csrf : '';
			jQuery.ajax({
				url : url + '.json' + sCsrfToken,
				dataType : 'json',
				success  : function(data) {
					if (data.data.error) {
						uAdmin.eip.message(data.data.error);
						return;
					}
					jQuery.openPopupLayer({
						'name'   : "CreatePage",
						'title'  : getLabel('js-eip-create-page'),
						'url'    : url + sCsrfToken,
						'beforeClose': function () {
							if (needReload) {
								document.location.reload();
								return false;
							};
						}
					});
				},
				error : function() {
					uAdmin.eip.message(getLabel('error-require-more-permissions'));
					return;
				}
			});
		};
	}, 'eip');


	uAdmin('placeWith', function (placer, node, fDim, sDim) {
		if(!placer || !node) return;
		var position = this.nodePositionInfo(placer);
		var region = jQuery(node);

		var x, y;
		switch(fDim) {
			case 'top':
				y = position.y - parseInt(region.css('height'));
				break;

			case 'right':
				x = position.x + position.width;
				break;

			case 'left':
				x = position.x - region.width();
				break;

			default:
				y = position.y + position.height;
		}

		if (fDim == 'top' || fDim == 'bottom') {
			switch(sDim) {
				case 'right':
					x = position.x + position.width;
					break;

				case 'middle':
				case 'center':
					if (position.width - parseInt(region.css('width')) > 0) {
						x = position.x + Math.ceil((position.width - region.width()) / 2);
					}
					else x = position.x;
					break;

				default: x = position.x;
					x += parseInt(jQuery(placer).css('padding-left'));
			}
		}
		else {
			switch(sDim) {
				case 'top':
					y = position.y;
					break;

				case 'bottom':
					y = position.y + position.height - parseInt(region.css('height'));
					break;

				default:
					y = Math.round(position.y + Math.ceil((position.height - parseInt(region.css('height'))) / 2));
			}
		}

		var rightBound = x;
		var jWindow = jQuery(window);

		if (rightBound > jWindow.width()) {
			x = jWindow.width() - region.width() - 30;
		}

		try {
			region.css({
				'position':		'absolute',
				'left':			x + 'px',
				'top':			y + 'px',
				'z-index':		560
			});
		} catch(e) {};

	}, 'eip');


	uAdmin('switchElementActivity', function (iElementId) {

		var eip = this;

		var bLoading = $('a#'+iElementId).hasClass('loading');
		if (bLoading) return false;

		$('a#'+iElementId).addClass('loading');

		var oParams = {};

		$.ajax({
			type: "POST",
			url: "/udata/content/activityControl/" + iElementId + ".json",
			data: oParams,
			dataType: "json",
			success: function(data){
				if (data.success) {
					eip.updateElementActivityView(iElementId, data.result);
				}
				$('a#'+iElementId).removeClass('loading');
			},
			error: function(jqXHR, textStatus, errorThrown) {
				console.log('error on switching activity: ' + textStatus);
			},
			complete: function() {
				$('a#'+iElementId).removeClass('loading');
			}
		});

		return false;

	}, 'eip');


	uAdmin('updateElementActivityView', function (iElementId, iNewState) {
		switch (iNewState) {
			case 1:
				$('a#'+iElementId).attr('class', 'deactivateButton');
				$('a#'+iElementId).parents('.cat-item-inactive').addClass('cat-item-active');
				$('a#'+iElementId).parents('.cat-item-inactive').removeClass('cat-item-inactive');
				$('a#'+iElementId).text('Активно');
				break;
			case -1:
				$('a#'+iElementId).attr('class', 'activateButton');
				$('a#'+iElementId).parents('.cat-item-active').addClass('cat-item-inactive');
				$('a#'+iElementId).parents('.cat-item-active').removeClass('cat-item-active');
				$('a#'+iElementId).text('Неактивно');
				break;
		}
	}, 'eip');


	uAdmin('initElementActivitySwitchers', function () {

		var eip = this;
		jQuery('.cat-item-active, .cat-item-inactive').each(function() {

			var iElementId = jQuery(this).attr('umi:element-id'),
				sActivityClass = '',
				sActivityTitle = '';

			if (jQuery(this).is('.cat-item-active')) {
				sActivityClass = 'deactivateButton';
				sActivityTitle = 'Активно';
			} else if (jQuery(this).is('.cat-item-inactive')) {
				sActivityClass = 'activateButton';
				sActivityTitle = 'Неактивно';
			};

			var jqButton = jQuery("<a />")
				.addClass(sActivityClass)
				.attr({
					'id': iElementId,
					'href': 'javascript:void(0)'
				})
				.text(sActivityTitle)
				.bind('click', function () {
					eip.switchElementActivity(iElementId);
				});

			var jqElement = jQuery("<div />")
				.addClass('actWrapper hidden')
				.append(jqButton)
				.append("<div class='cleaner' />");

			if (jQuery(this).is('tr')) {
				jqElement = jQuery("<td />").append(jqElement);
			};

			jQuery(this).prepend(jqElement);

		});

	}, 'eip');


	uAdmin('drawControls',function () {
		this.editorToggleButton = this.addEditorToggleButton();
		this.editorControlsHolder = this.addEditorControlsHolder();
		this.saveButton = this.addSaveButton();
		this.undoButton = this.addUndoButton();
		this.redoButton = this.addRedoButton();
		this.initElementActivitySwitchers();
		this.initCustomControls();
	}, 'eip');

	
	uAdmin('initCustomControls', function () {
		
		this.bind('Enable', function (type) {
			if (type == 'after') {
				jQuery('.actWrapper').show();
				jQuery('.catalog-objects-amount').show();
				jQuery('.cat-item-inactive').show();
				jQuery('.hidden').addClass('not_hidden').removeClass('hidden');
				uAdmin.eip.normalizeBoxes();
			};
		});
		
		this.bind('Disable', function (type) {
			if (type == 'after') {
				jQuery('.actWrapper').hide();
				jQuery('.cat-item-inactive').hide();
				jQuery('.catalog-objects-amount').hide();
				jQuery('.not_hidden').addClass('hidden').removeClass('not_hidden');
				uAdmin.eip.normalizeBoxes();
			};		
		});
		
	}, 'eip');


	uAdmin('disable', function () {

		this.onDisable('before');
		this.finishLast();
		this.unhighlight();

		this.enabled = false;

		jQuery.cookie('eip-editor-state', '', { path: '/', expires: 0});
		this.queue.setSaveStatus(false);
		this.message(getLabel('js-panel-message-edit-off'));

		if (this.queue.current >= 0) {
			this.queue.save();
		}
		jQuery(document).unbind('keydown', this.bindHotkeys);
		this.onDisable('after');
	}, 'eip');

	uAdmin('addMetaPanel', function () {
		if (!uAdmin.panel.panelHolder) return null;
		var self = this;
		return jQuery('\n\
				<div id="u-quickpanel-meta">\n\
					<table>\n\
						<tr>\n\
							<td width="100px">' + getLabel('js-panel-meta-altname') + ': </td>\n\
							<td>\n\
								<input type="text" name="alt_name" id="u-quickpanel-metaaltname" value="' + self.meta.old.alt_name + '"/>\n\
								<div class="meta_count" id="u-quickpanel-metaaltname-count"/>\n\
							</td>\n\
						</tr>\n\
						<tr>\n\
							<td width="100px">' + getLabel('js-panel-meta-title') + ': </td>\n\
							<td>\n\
								<input type="text" name="title" id="u-quickpanel-metatitle" value="' + self.meta.old.title + '"/>\n\
								<div class="meta_count" id="u-quickpanel-metatitle-count"/>\n\
							</td>\n\
						</tr>\n\
						<tr>\n\
							<td>' + getLabel('js-panel-meta-keywords') + ': </td>\n\
							<td>\n\
								<input type="text" name="meta_keywords" id="u-quickpanel-metakeywords" value="' + self.meta.old.keywords + '"/>\n\
								<div class="meta_count" id="u-quickpanel-metakeywords-count"/>\n\
							</td>\n\
						</tr>\n\
						<tr>\n\
							<td>' + getLabel('js-panel-meta-descriptions') + ':</td>\n\
							<td>\n\
								<input type="text" name="meta_descriptions" id="u-quickpanel-metadescription" value="' + self.meta.old.descriptions + '"/>\n\
								<div class="meta_count" id="u-quickpanel-metadescription-count"/>\n\
								<div class="meta_buttons">\n\
									<input type="submit" id="save_meta_button" value="' + getLabel('js-panel-save') + '">\n\
								</div>\n\
							</td>\n\
						</tr>\n\
					</table>\n\
				</div>\n\
			').appendTo(uAdmin.panel.panelHolder);
	}, 'eip');

})();

uAdmin.onLoad('eip', function(){

	var eip = uAdmin.eip;

	var defaultSetSaveStatusHandler = eip.queue.setSaveStatus;
	eip.queue.setSaveStatus = function (bStatus) {
		bStatus = !!bStatus;

		if (typeof defaultSetSaveStatusHandler == 'function') {
			defaultSetSaveStatusHandler(bStatus);
		};

		if (bStatus) {
			eip.editorToggleButton.setLabelText(getLabel('js-panel-edit-save'));
		} else {
			eip.editorToggleButton.setLabelText(getLabel('js-panel-edit'));
		}
	};

});
