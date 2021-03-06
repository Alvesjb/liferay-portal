/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.liferay.staging.taglib.servlet.taglib;

import aQute.bnd.annotation.ProviderType;

import com.liferay.staging.taglib.internal.servlet.ServletContextUtil;
import com.liferay.taglib.util.IncludeTag;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.PageContext;

/**
 * @author Peter Borkuti
 */
@ProviderType
public class IncompleteProcessMessageTag extends IncludeTag {

	public void setLocalPublishing(boolean localPublishing) {
		_localPublishing = localPublishing;
	}

	@Override
	public void setPageContext(PageContext pageContext) {
		super.setPageContext(pageContext);

		servletContext = ServletContextUtil.getServletContext();
	}

	public void setTaskExecutorClassName(String taskExecutorClassName) {
		_taskExecutorClassName = taskExecutorClassName;
	}

	@Override
	protected void cleanUp() {
		super.cleanUp();

		_localPublishing = false;
		_taskExecutorClassName = null;
	}

	@Override
	protected String getPage() {
		return _PAGE;
	}

	@Override
	protected void setAttributes(HttpServletRequest request) {
		request.setAttribute(
			"liferay-staging:incomplete-process-message:localPublishing",
			_localPublishing);
		request.setAttribute(
			"liferay-staging:incomplete-process-message:taskExecutorClassName",
			_taskExecutorClassName);
	}

	private static final String _PAGE = "/incomplete_process_message/page.jsp";

	private boolean _localPublishing;
	private String _taskExecutorClassName;

}