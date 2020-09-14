<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

    <xsl:template match="udata[@module = 'blogs20' and @method = 'checkAllowComments']" />

    <xsl:template match="udata[@module = 'blogs20'][@method = 'checkAllowComments'][. = 1]">
        <div class="comments_form_div">
            <a name="add-comment" />
            <div class="comment_add_form_h2 h2" umi:element-id="{$infoPageId}" umi:empty="&empty-comments-title;" umi:field-name="add_comment_title" umi:field-type="string">
                <xsl:apply-templates select="$infoPage/property[@name = 'add_comment_title']" />
            </div>
            <form class="site_form comments_form" method="post" action="/blogs20/commentAdd/{$pageId}/">
                <fieldset>
                    <div class="field title">
                        <label>
                            <span>&comment-title;:</span>
                        </label>
                        <div class="field_div input">
                            <input type="text" name="title"/>
                        </div>
                    </div>
                    <xsl:if test="$userType = 'guest'">
                        <div class="field author_nick">
                            <label>
                                <span>&comment-name;:</span>
                            </label>
                            <div class="field_div input">
                                <input type="text" name="author_nick"/>
                            </div>
                        </div>
                        <div class="field author_email">
                            <label>
                                <span>&comment-email;:</span>
                            </label>
                            <div class="field_div input">
                                <input type="text" name="author_email"/>
                            </div>
                        </div>
                    </xsl:if>
                    <div class="field comment">
                        <label>
                            <span>&comment-body;:</span>
                        </label>
                        <div class="field_div textarea">
                            <textarea name="comment" />
                        </div>
                    </div>
                    <xsl:apply-templates select="document('udata://system/captcha/')/udata" />
                    <xsl:call-template name="personal_data_notice" />
                </fieldset>
                <fieldset>
                    <div class="submit">
                        <input type="submit" class="all_system_buttons" value="&comment-submit;" />
                    </div>
                </fieldset>
            </form>
        </div>
    </xsl:template>

</xsl:stylesheet>
