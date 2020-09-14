<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

    <xsl:template match="result[@module = 'users'][@method = 'login' or @method = 'login_do' or @method = 'auth']">
        <xsl:choose>
			<xsl:when test="$isAdmin = 1">
				<xsl:call-template name="login_admin"/>
			</xsl:when>
            <xsl:when test="$userType = 'guest'">
                <xsl:if test="@method = 'login_do'">
                    <div class="text">
                        <p>&user-reauth;</p>
                    </div>
                </xsl:if>
                <xsl:call-template name="login_form"/>
			</xsl:when>
			<xsl:otherwise>
                <xsl:call-template name="login_logged"/>
			</xsl:otherwise>
		</xsl:choose>
    </xsl:template>
    
    <xsl:template name="login_form">
        <form class="site_form" action="/users/login_do/" method="post">
			<fieldset>
                <xsl:choose>
                    <xsl:when test="@method = 'login_do'">
                        <input type="hidden" name="from_page" value="/users/settings/" />
                    </xsl:when>
                    <xsl:otherwise>
                        <input type="hidden" name="from_page" value="{$_http_referer}" />
                    </xsl:otherwise>
                </xsl:choose>
				<div class="field field_email required">
					<label>
						<span>&e-mail;:</span>
						<span class="required_star" title="&required-text;" ><span class="required_star_text">*</span></span>
					</label>
					<div class="field_div input">
						<input type="text" name="login"/>
					</div>
				</div>
                <div class="field field_password required">
					<label>
						<span>&password;:</span>
						<span class="required_star" title="&required-text;" ><span class="required_star_text">*</span></span>
					</label>
					<div class="field_div input">
						<input type="password" name="password"/>
					</div>
				</div>

				<xsl:call-template name="personal_data_notice" />
			</fieldset>
			<fieldset>
                <div class="submit">
                    <a href="/users/forget/" class="additional_link">&forget-password;</a>
                    <a href="/users/registrate/" class="additional_link">&registration;</a>
                    <input type="submit" class="all_system_buttons" value="&log-in;" />
                </div>
            </fieldset>
		</form>
    </xsl:template>
    
    <xsl:template name="login_logged">
		<div class="text">
			&user-welcome;
		</div>
        <div class="system_buttons_list">
			<a href="/users/settings/?personal_office=1" class="all_system_buttons">&my_settings;</a>
			<xsl:if test="$сatalog = 1">
				<a href="/emarket/personal/?personal_office=1" class="all_system_buttons">&my_orders;</a>
				<a href="/emarket/cart/?personal_office=1" class="all_system_buttons">&my_basket;</a>
			</xsl:if>
            <a href="/users/logout/" class="all_system_buttons last_system_button">&log-out;</a>
        </div>
    </xsl:template>
    
    <xsl:template name="login_admin">
        <div class="text">
            <p>&admin-welcome;</p>
        </div>
        <div>
            <a href="/users/logout/" class="all_system_buttons">&log-out;</a>
        </div>
    </xsl:template>

</xsl:stylesheet>
