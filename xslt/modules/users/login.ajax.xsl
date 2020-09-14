<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
	<!--AJAX авторизация-->
	<xsl:template name="ajax-login">
		<xsl:choose>
            <xsl:when test="$ajaxUserType = 'guest'">
                <xsl:call-template name="ajax-login-form"/>
			</xsl:when>
			<xsl:otherwise>
                <xsl:call-template name="ajax-login-logged"/>
			</xsl:otherwise>
		</xsl:choose>
    </xsl:template>
	
	<xsl:template name="ajax-login-form">
		<a class="ajax_login_toggle ajax_login_toggle_icon" href="/users/login/" title="&authorization;"><span>&nbsp;</span></a>
		<div id="authorization_wrapper">
			<div class="ajax_login_title">
				<a href="/users/login/?personal_office=1">&authorization;</a>
				<a class="ajax_login_toggle ajax_login_toggle_close_icon"><span>&nbsp;</span></a>
			</div>
			<form id="ajax_login_form" class="ajax_login_form" action="/users/login_do/" method="post">
				<fieldset id="ajax_login_field">
					<div class="field login required">
						<div class="field_div input">
							<input title="&e-mail;" type="text" name="login" class="form_placeholder"/>
						</div>
					</div>
					<div class="field password required">
						<div class="field_div input">
							<input title="&password;" type="password" name="password" class="form_placeholder"/>
						</div>
					</div>
					<div class="cleaner"/>
					<div id="ajax_login_error" class="ajax_login_messages">
						<span>
							&ajax-user-reauth;
						</span>
					</div>
					<div id="ajax_login_ok" class="ajax_login_messages">
						<span>
							&ajax-user-welcome;
						</span>
					</div>

					<xsl:call-template name="personal_data_notice" />
				</fieldset>
				<fieldset>
					<input type="hidden" name="from_page" value="{$_request_uri}" />
					<div class="submit">
						<a href="/users/registrate/" class="additional_link">&registration-do;</a>
						<a href="/users/forget/" class="additional_link">&forget-password;</a>
						<input type="submit" class="all_system_buttons" value="&log-in;" />
					</div>
				</fieldset>
			</form>
		</div>
    </xsl:template>
    
    <xsl:template name="ajax-login-logged">
		<a class="ajax_login_toggle ajax_login_toggle_icon" href="/users/login/" title="&private_office;"><span>&nbsp;</span></a>
		<div id="authorization_wrapper">
			<div class="ajax_login_title">
				<a href="/users/settings/?personal_office=1">&private_office;</a>
				<a class="ajax_login_toggle ajax_login_toggle_close_icon"><span>&nbsp;</span></a>
			</div>
			<div class="personal_options">
				<ul>
					<li class="personal_options_settings">
						<a href="/users/settings/?personal_office=1">&my_settings;</a>
					</li>
					<li class="personal_options_orders">
						<a href="/emarket/personal/?personal_office=1">&my_orders;</a>
					</li>
					<li class="personal_options_basket">
						<a href="/emarket/cart/?personal_office=1">&my_basket;</a>
					</li>
					<li class="personal_options_logout">
						<a href="/users/logout/">&log-out;</a>
					</li>
				</ul>
			</div>
		</div>
    </xsl:template>

</xsl:stylesheet>
