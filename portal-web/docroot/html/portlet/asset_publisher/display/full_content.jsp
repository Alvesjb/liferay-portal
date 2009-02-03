<%
/**
 * Copyright (c) 2000-2009 Liferay, Inc. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
%>

<%@ include file="/html/portlet/asset_publisher/init.jsp" %>

<%
List results = (List)request.getAttribute("view.jsp-results");

int assetIndex = ((Integer)request.getAttribute("view.jsp-assetIndex")).intValue();

TagsAsset asset = (TagsAsset)request.getAttribute("view.jsp-asset");

String title = (String)request.getAttribute("view.jsp-title");

String className = (String)request.getAttribute("view.jsp-className");
long classPK = ((Long)request.getAttribute("view.jsp-classPK")).longValue();

boolean show = ((Boolean)request.getAttribute("view.jsp-show")).booleanValue();

request.setAttribute ("view.jsp-showIconLabel", true);
%>

<c:choose>
	<c:when test="<%= className.equals(BlogsEntry.class.getName()) %>">

		<%
		BlogsEntry entry = BlogsEntryLocalServiceUtil.getEntry(classPK);

		PortletURL viewFullContentURL = renderResponse.createRenderURL();

		viewFullContentURL.setParameter("struts_action", "/asset_publisher/view_content");
		viewFullContentURL.setParameter("redirect", currentURL);
		viewFullContentURL.setParameter("assetId", String.valueOf(asset.getAssetId()));
		%>

		<c:choose>
			<c:when test="<%= showAssetTitle %>">
				<h3 class="asset-title blog-entry">
					<liferay-util:include page="/html/portlet/asset_publisher/asset_actions.jsp" />
					<%= title %>
				</h3>
			</c:when>
			<c:otherwise>
				<div class="asset-edit">
					<liferay-util:include page="/html/portlet/asset_publisher/asset_actions.jsp" />
				</div>
			</c:otherwise>
		</c:choose>

		<div class="asset-content">
			<%= entry.getContent() %>

			<c:if test="<%= showContextLink %>">
				<div class="asset-more">
					<a href="<%= themeDisplay.getPathMain() %>/blogs/find_entry?entryId=<%= entry.getEntryId() %>&notFoundRedirect=<%= HttpUtil.encodeURL(viewFullContentURL.toString()) %>"><liferay-ui:message key="view-blog" /> &raquo;</a>
				</div>
			</c:if>

			<c:if test="<%= enableRatings %>">
				<liferay-ui:ratings
					className="<%= BlogsEntry.class.getName() %>"
					classPK="<%= entry.getEntryId() %>"
					url='<%= themeDisplay.getPathMain() + "/blogs/rate_entry?p_p_id=" + portletDisplay.getId() %>'
				/>
			</c:if>

			<c:if test="<%= enableComments %>">
				<br />

				<portlet:actionURL var="discussionURL">
					<portlet:param name="struts_action" value="/asset_publisher/edit_entry_discussion" />
				</portlet:actionURL>

				<liferay-ui:discussion
					formName='<%= "fm" + entry.getEntryId() %>'
					formAction="<%= discussionURL %>"
					className="<%= BlogsEntry.class.getName() %>"
					classPK="<%= entry.getEntryId() %>"
					userId="<%= entry.getUserId() %>"
					subject="<%= entry.getTitle() %>"
					redirect="<%= currentURL %>"
					ratingsEnabled="<%= enableCommentRatings %>"
				/>
			</c:if>
		</div>
	</c:when>
	<c:when test="<%= className.equals(BookmarksEntry.class.getName()) %>">

		<%
		BookmarksEntry entry = BookmarksEntryLocalServiceUtil.getEntry(classPK);
		%>

		<c:choose>
			<c:when test="<%= showAssetTitle %>">
				<h3 class="asset-title bookmark-entry">
					<liferay-util:include page="/html/portlet/asset_publisher/asset_actions.jsp" />
					<%= title %>
				</h3>
			</c:when>
			<c:otherwise>
				<div class="asset-edit">
					<liferay-util:include page="/html/portlet/asset_publisher/asset_actions.jsp" />
				</div>
			</c:otherwise>
		</c:choose>

		<div class="asset-content">
			<a href="<%= entry.getUrl() %>" target="_blank">
				<c:choose>
					<c:when test="<%= showAssetTitle %>">
						<%= entry.getUrl() %>
					</c:when>
					<c:otherwise>
						<%= entry.getName() %>
					</c:otherwise>
				</c:choose>
			</a>

			<p class="asset-description"><%= entry.getComments() %></p>
		</div>
	</c:when>
	<c:when test="<%= className.equals(DLFileEntry.class.getName()) %>">

		<%
		DLFileEntry fileEntry = DLFileEntryLocalServiceUtil.getFileEntry(classPK);

		PortletURL docURL = new PortletURLImpl(request, PortletKeys.DOCUMENT_LIBRARY, plid, PortletRequest.RENDER_PHASE);

		docURL.setWindowState(WindowState.MAXIMIZED);

		docURL.setParameter("struts_action", "/document_library/view");
		docURL.setParameter("folderId", String.valueOf(fileEntry.getFolderId()));
		%>

		<c:choose>
			<c:when test="<%= showAssetTitle %>">
				<h3 class="asset-title dl-file-entry">
					<liferay-util:include page="/html/portlet/asset_publisher/asset_actions.jsp" />
					<%= title %>
				</h3>
			</c:when>
			<c:otherwise>
				<div class="asset-edit">
					<liferay-util:include page="/html/portlet/asset_publisher/asset_actions.jsp" />
				</div>
			</c:otherwise>
		</c:choose>

		<div class="asset-content">
			<a href="<%= themeDisplay.getPathMain() %>/document_library/get_file?p_l_id=<%= themeDisplay.getPlid() %>&folderId=<%= fileEntry.getFolderId() %>&name=<%= HttpUtil.encodeURL(fileEntry.getName()) %>">
				<img align="left" border="0" class="dl-file-icon" src="<%= themeDisplay.getPathThemeImages() %>/document_library/<%= DLUtil.getFileExtension(fileEntry.getName()) %>.png" /><%= fileEntry.getTitle() %>
			</a>

			<p class="asset-description"><%= fileEntry.getDescription() %></p>

			<c:if test="<%= showContextLink %>">
				<div class="asset-more">
					<a href="<%= docURL.toString() %>"><liferay-ui:message key="view-folder" /> &raquo;</a>
				</div>
			</c:if>

			<c:if test="<%= enableRatings %>">
				<br />

				<liferay-ui:ratings
					className="<%= DLFileEntry.class.getName() %>"
					classPK="<%= fileEntry.getFileEntryId() %>"
					url='<%= themeDisplay.getPathMain() + "/document_library/rate_file_entry?p_p_id=" + portletDisplay.getId() %>'
				/>
			</c:if>

			<c:if test="<%= enableComments %>">
				<br />

				<portlet:actionURL var="discussionURL">
					<portlet:param name="struts_action" value="/asset_publisher/edit_file_entry_discussion" />
				</portlet:actionURL>

				<liferay-ui:discussion
					formName='<%= "fm" + fileEntry.getFileEntryId() %>'
					formAction="<%= discussionURL %>"
					className="<%= DLFileEntry.class.getName() %>"
					classPK="<%= fileEntry.getFileEntryId() %>"
					userId="<%= fileEntry.getUserId() %>"
					subject="<%= fileEntry.getTitle() %>"
					redirect="<%= currentURL %>"
				/>
			</c:if>
		</div>
	</c:when>
	<c:when test="<%= className.equals(IGImage.class.getName()) %>">

		<%
		IGImage image = IGImageLocalServiceUtil.getImage(classPK);

		PortletURL imageURL = new PortletURLImpl(request, PortletKeys.IMAGE_GALLERY, plid, PortletRequest.RENDER_PHASE);

		imageURL.setWindowState(WindowState.MAXIMIZED);

		imageURL.setParameter("struts_action", "/image_gallery/view");
		imageURL.setParameter("folderId", String.valueOf(image.getFolderId()));
		%>

		<c:choose>
			<c:when test="<%= showAssetTitle %>">
				<h3 class="asset-title image">
					<liferay-util:include page="/html/portlet/asset_publisher/asset_actions.jsp" />
					<%= title %>
				</h3>
			</c:when>
			<c:otherwise>
				<div class="asset-edit">
					<liferay-util:include page="/html/portlet/asset_publisher/asset_actions.jsp" />
				</div>
			</c:otherwise>
		</c:choose>

		<div class="asset-content">
			<img border="1" src="<%= themeDisplay.getPathImage() %>/image_gallery?img_id=<%= image.getLargeImageId() %>&t=<%= ImageServletTokenUtil.getToken(image.getLargeImageId()) %>" />

			<p class="asset-description"><%= image.getDescription() %></p>

			<c:if test="<%= showContextLink %>">
				<div class="asset-more">
					<a href="<%= imageURL.toString() %>"><liferay-ui:message key="view-album" /> &raquo;</a>
				</div>
			</c:if>

		</div>
	</c:when>
	<c:when test="<%= className.equals(JournalArticle.class.getName()) %>">

		<%
		JournalArticleResource articleResource = JournalArticleResourceLocalServiceUtil.getArticleResource(classPK);

		String templateId = (String)request.getAttribute(WebKeys.JOURNAL_TEMPLATE_ID);
		String languageId = LanguageUtil.getLanguageId(request);
		int articlePage = ParamUtil.getInteger(request, "page", 1);
		String xmlRequest = PortletRequestUtil.toXML(renderRequest, renderResponse);

		JournalArticleDisplay articleDisplay = JournalContentUtil.getDisplay(articleResource.getGroupId(), articleResource.getArticleId(), templateId, null, languageId, themeDisplay, articlePage, xmlRequest);

		if (articleDisplay == null) {

			// No version has been approved yet, the article should not be rendered

			show = false;
		}
		%>

		<c:if test="<%= articleDisplay != null %>">

			<c:choose>
				<c:when test="<%= showAssetTitle %>">
					<h3 class="asset-title web-content">
						<liferay-util:include page="/html/portlet/asset_publisher/asset_actions.jsp" />
						<%= title %>
					</h3>
				</c:when>
				<c:otherwise>
					<div class="asset-edit">
						<liferay-util:include page="/html/portlet/asset_publisher/asset_actions.jsp" />
					</div>
				</c:otherwise>
			</c:choose>

			<div class="asset-content">
				<c:if test="<%= showAvailableLocales %>">

					<%
					String[] availableLocales = articleDisplay.getAvailableLocales();
					%>

					<c:if test="<%= availableLocales.length > 0 %>">
						<div>
							<br />

							<liferay-ui:language languageIds="<%= availableLocales %>" displayStyle="<%= 0 %>" />
						</div>
					</c:if>
				</c:if>

				<div class="journal-content-article">
					<%= articleDisplay.getContent() %>
				</div>

				<c:if test="<%= articleDisplay.isPaginate() %>">

					<%
					String pageRedirect = ParamUtil.getString(request, "redirect");

					if (Validator.isNull(pageRedirect)) {
						pageRedirect = currentURL;
					}

					int cur = ParamUtil.getInteger(request, "cur");

					PortletURL articlePageURL = renderResponse.createRenderURL();

					articlePageURL.setParameter("struts_action", "/asset_publisher/view_content");
					articlePageURL.setParameter("redirect", pageRedirect);
					articlePageURL.setParameter("assetId", String.valueOf(asset.getAssetId()));
					articlePageURL.setParameter("cur", String.valueOf(cur));
					%>

					<br />

					<liferay-ui:page-iterator
						cur="<%= articleDisplay.getCurrentPage() %>"
						curParam="page"
						delta="<%= 1 %>"
						maxPages="<%= 25 %>"
						total="<%= articleDisplay.getNumberOfPages() %>"
						type="article"
						url="<%= articlePageURL.toString() %>"
					/>

					<br />
				</c:if>

				<c:if test="<%= enableRatings %>">
					<br />

					<liferay-ui:ratings
						className="<%= JournalArticle.class.getName() %>"
						classPK="<%= articleDisplay.getResourcePrimKey() %>"
						url='<%= themeDisplay.getPathMain() + "/journal_content/rate_entry?p_p_id=" + portletDisplay.getId() %>'
					/>
				</c:if>

				<c:if test="<%= enableComments %>">
					<br />

					<portlet:actionURL var="discussionURL">
						<portlet:param name="struts_action" value="/asset_publisher/edit_article_discussion" />
					</portlet:actionURL>

					<liferay-ui:discussion
						formName='<%= "fm" + articleDisplay.getResourcePrimKey() %>'
						formAction="<%= discussionURL %>"
						className="<%= JournalArticle.class.getName() %>"
						classPK="<%= articleDisplay.getResourcePrimKey() %>"
						userId="<%= articleDisplay.getUserId() %>"
						subject="<%= articleDisplay.getTitle() %>"
						redirect="<%= currentURL %>"
					/>
				</c:if>
			</c:if>
		</div>
	</c:when>
	<c:when test="<%= className.equals(MBMessage.class.getName()) %>">

		<%
		MBMessage message = MBMessageLocalServiceUtil.getMessage(classPK);
		%>

		<c:choose>
			<c:when test="<%= showAssetTitle %>">
				<h3 class="asset-title mb-entry">
					<liferay-util:include page="/html/portlet/asset_publisher/asset_actions.jsp" />
					<%= message.getSubject() %>
				</h3>
			</c:when>
			<c:otherwise>
				<div class="asset-edit">
					<liferay-util:include page="/html/portlet/asset_publisher/asset_actions.jsp" />
				</div>
			</c:otherwise>
		</c:choose>

		<div class="asset-content">
			<%= message.getBody() %>

			<c:if test="<%= showContextLink %>">
				<div class="asset-more">
					<a href="<%= themeDisplay.getPathMain() %>/message_boards/find_message?messageId=<%= message.getMessageId() %>"><liferay-ui:message key="view-thread" /> &raquo;</a>
				</div>
			</c:if>
		</div>
	</c:when>
	<c:when test="<%= className.equals(WikiPage.class.getName()) %>">

		<c:choose>
			<c:when test="<%= showAssetTitle %>">
				<h3 class="asset-title wiki-page">
					<liferay-util:include page="/html/portlet/asset_publisher/asset_actions.jsp" />
					<%= title %>
				</h3>
			</c:when>
			<c:otherwise>
				<div class="asset-edit">
					<liferay-util:include page="/html/portlet/asset_publisher/asset_actions.jsp" />
				</div>
			</c:otherwise>
		</c:choose>

		<div class="asset-content">
			<div class="content-body">

				<%
				WikiPageResource pageResource = WikiPageResourceLocalServiceUtil.getPageResource(classPK);

				WikiPage wikiPage = WikiPageLocalServiceUtil.getPage(pageResource.getNodeId(), pageResource.getTitle());

				try {
					PortletURL viewPageURL = new PortletURLImpl(request, PortletKeys.WIKI, plid, PortletRequest.ACTION_PHASE);

					viewPageURL.setPortletMode(PortletMode.VIEW);

					viewPageURL.setParameter("struts_action", "/wiki/view");

					PortletURL editPageURL = new PortletURLImpl(request, PortletKeys.WIKI, plid, PortletRequest.ACTION_PHASE);

					editPageURL.setPortletMode(PortletMode.VIEW);

					editPageURL.setParameter("struts_action", "/wiki/edit_page");

					String attachmentURLPrefix = themeDisplay.getPathMain() + "/wiki/get_page_attachment?p_l_id=" + themeDisplay.getPlid() + "&nodeId=" + wikiPage.getNodeId() + "&title=" + HttpUtil.encodeURL(wikiPage.getTitle()) + "&fileName=";

					WikiPageDisplay pageDisplay = WikiCacheUtil.getDisplay(wikiPage.getNodeId(), wikiPage.getTitle(), viewPageURL, editPageURL, attachmentURLPrefix);
				%>

					<%= pageDisplay.getFormattedContent() %>

				<%
				}
				catch (Exception e) {
					_log.error("Error formatting the wiki page " + wikiPage.getPageId() + " with the format " + wikiPage.getFormat(), e);
				%>

					<%= LanguageUtil.get(pageContext, "error-formatting-the-page") %>

				<%
				}
				%>

				<c:if test="<%= showContextLink %>">
					<div class="asset-more">
						<a href="<%= themeDisplay.getURLPortal() + themeDisplay.getPathMain() + "/wiki/find_page?pageResourcePrimKey=" + wikiPage.getResourcePrimKey() %>"><liferay-ui:message key="view-wiki" /> &raquo;</a>
					</div>
				</c:if>

			</div>

			<c:if test="<%= enableComments %>">
				<br />

				<portlet:actionURL var="discussionURL">
					<portlet:param name="struts_action" value="/asset_publisher/edit_page_discussion" />
				</portlet:actionURL>

				<liferay-ui:discussion
					formName='<%= "fm" + wikiPage.getResourcePrimKey() %>'
					formAction="<%= discussionURL %>"
					className="<%= WikiPage.class.getName() %>"
					classPK="<%= wikiPage.getResourcePrimKey() %>"
					userId="<%= wikiPage.getUserId() %>"
					subject="<%= wikiPage.getTitle() %>"
					redirect="<%= currentURL %>"
				/>
			</c:if>
		</div>
	</c:when>
	<c:otherwise>
		<%= className %> is not a valid type.
	</c:otherwise>
</c:choose>

<c:if test="<%= show %>">
	<div class="asset-metadata">
		<%@ include file="/html/portlet/asset_publisher/asset_metadata.jspf" %>
	</div>
</c:if>

<c:choose>
	<c:when test="<%= !showAssetTitle && ((assetIndex + 1) < results.size()) %>">
		<div class="separator"><!-- --></div>
	</c:when>
	<c:when test="<%= (assetIndex + 1) == results.size() %>">
		<div class="final-separator"><!-- --></div>
	</c:when>
</c:choose>

<%!
private static Log _log = LogFactoryUtil.getLog("portal-web.docroot.html.portlet.asset_publisher.display_full_content.jsp");
%>