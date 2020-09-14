<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="udata[@module = 'webforms'][@method = 'add']">
		<form method="post" action="/webforms/send/" class="site_form feedback_form">
			<fieldset>
				<input type="hidden" name="system_form_id" value="{@form_id}" />
				<input type="hidden" name="ref_onsuccess" value="/webforms/posted/" />
				<xsl:apply-templates select="items" mode="address" />
				<xsl:apply-templates select="groups/group/field" />
				<xsl:apply-templates select="document('udata://system/captcha/')/udata" />
				<xsl:call-template name="personal_data_notice" />
			</fieldset>
			<fieldset>
				<div class="submit">
					<input type="submit" class="all_system_buttons" value="&send;" />
				</div>
			</fieldset>
		</form>
	</xsl:template>

	<xsl:template match="udata[@module = 'webforms'][@method = 'add']" mode="feedback">
		<form method="post" action="/webforms/send/" class="site_form feedback_form">
			<fieldset>
				<input type="hidden" name="system_form_id" value="{@form_id}" />
				<input type="hidden" name="ref_onsuccess" value="/webforms/posted/" />
				<xsl:apply-templates select="items" mode="address" />
				<div class="required field field_autor">
					<label>
						<span>&feedback-autor;:</span>
						<span class="required_star" title="&required-text;" ><span class="required_star_text">*</span></span>
					</label>
					<div class="field_div input">
						<input name="data[new][autor]" value="" type="text"/>
					</div>
					<div class="webforms_error_text">
						&webforms-error-text;
					</div>
				</div>
				<div class="required field field_email">
					<label>
						<span>&feedback-email;:</span>
						<span class="required_star" title="&required-text;" ><span class="required_star_text">*</span></span>
					</label>
					<div class="field_div input">
						<input name="data[new][email]" value="" type="text"/>
					</div>
					<div class="webforms_error_text">
						&webforms-error-text;
					</div>
					<div class="email_error_text">
						&email-error-text;
					</div>
				</div>
				<div class="required field field_theme">
					<label>
						<span>&feedback-theme;:</span>
						<span class="required_star" title="&required-text;" ><span class="required_star_text">*</span></span>
					</label>
					<div class="field_div input">
						<input name="data[new][theme]" value="" type="text"/>
					</div>
					<div class="webforms_error_text">
						&webforms-error-text;
					</div>
				</div>
				<div class="required field field_message">
					<label>
						<span>&feedback-message;:</span>
						<span class="required_star" title="&required-text;" ><span class="required_star_text">*</span></span>
					</label>
					<div class="field_div textarea">
						<textarea name="data[new][message]"></textarea>
					</div>
					<div class="webforms_error_text">
						&webforms-error-text;
					</div>
				</div>
				<xsl:apply-templates select="document('udata://system/captcha/')/udata" />
				<xsl:call-template name="personal_data_notice" />
			</fieldset>
			<fieldset>
				<div class="submit">
					<input type="submit" class="all_system_buttons" value="&send;" />
				</div>
			</fieldset>
		</form>
	</xsl:template>

	<xsl:template match="items" mode="address">
		<xsl:apply-templates select="item" mode="address" />
	</xsl:template>

	<xsl:template match="item" mode="address">
		<input type="hidden" name="system_email_to" value="{@id}" />
	</xsl:template>

	<xsl:template match="items[count(item) &gt; 1]" mode="address">
		<xsl:choose>
			<xsl:when test="count(item[@selected='selected']) != 1">
				<div class="form_element">
					<label class="required">
						<span><xsl:text>Кому отправить:</xsl:text></span>
						<select name="system_email_to">
							<option value=""></option>
							<xsl:apply-templates select="item" mode="address_select" />
						</select>
					</label>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="item[@selected='selected']" mode="address" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="item" mode="address_select">
		<option value="{@id}"><xsl:apply-templates /></option>
	</xsl:template>

</xsl:stylesheet>
