<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="result[@method = 'forget']">
		<xsl:choose>
			<xsl:when test="$isAdmin = 1">
				<xsl:call-template name="login_admin"/>
			</xsl:when>
			<xsl:otherwise>
                <xsl:call-template name="forget_form"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="forget_form">
        <form class="site_form" method="post" action="/users/forget_do/">
			<fieldset>
				<div class="field field_email field_forget_login required">
					<label>
						<span>&forget-label;:</span>
						<span class="required_star" title="&required-text;" ><span class="required_star_text">*</span></span>
					</label>
					<div class="field_div input">
						<input type="text" name="forget_login"/>
					</div>
					<div class="webforms_error_text">
						&webforms-error-text;
					</div>
					<div class="email_error_text">
						&email-error-text;
					</div>
				</div>

				<xsl:call-template name="personal_data_notice" />
			</fieldset>
			<fieldset>
                <div class="submit">
                    <input type="submit" class="all_system_buttons" value="&forget-button;" />
                </div>
            </fieldset>
		</form>
    </xsl:template>

	<xsl:template match="result[@method = 'forget_do']">
		<div class="text">
			<p>&forget-do-message;</p>
		</div>
	</xsl:template>
	
	<xsl:template match="result[@method = 'restore']">
		<div class="text">
			<p>&restore-message;</p>
		</div>
	</xsl:template>
	
</xsl:stylesheet>
