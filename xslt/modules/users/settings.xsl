<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="result[@method = 'settings']">
		<xsl:choose>
			<xsl:when test="$isAdmin = 1">
				<xsl:call-template name="login_admin"/>
			</xsl:when>
			<xsl:otherwise>
                <xsl:apply-templates select="document('udata://users/settings/')/udata" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'settings']">
		<xsl:variable name="user" select="document(concat('uobject://',$userId))/udata" />
		<form class="site_form" method="post" action="/users/custom_settings_do/">
			<fieldset>
				<div class="field field_email required">
					<label>
						<span>&e-mail;:</span>
						<span class="required_star" title="&required-text;" ><span class="required_star_text">*</span></span>
					</label>
					<div class="field_div input">
						<input type="text" name="email" value="{$user//group[@name = 'idetntify_data']/property[@name = 'e-mail']/value}"/>
					</div>
					<div class="webforms_error_text">
						&webforms-error-text;
					</div>
					<div class="email_error_text">
						&email-error-text;
					</div>
				</div>
                <div class="field password">
					<label>
						<span>&password;:</span>
					</label>
					<div class="field_div input">
						<input type="text" name="password"/>
					</div>
				</div>

				<xsl:call-template name="personal_data_notice" />

			</fieldset>
			<xsl:apply-templates select="document(concat('udata://data/getEditForm/', $userId))/udata" />
			<fieldset>
                <div class="submit">
                    <input type="submit" class="all_system_buttons" value="&save-changes;" />
                </div>
            </fieldset>
		</form>
	</xsl:template>

</xsl:stylesheet>
