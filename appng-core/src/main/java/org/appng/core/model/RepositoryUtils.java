/*
 * Copyright 2011-2020 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.appng.core.model;

import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.lang3.StringUtils;
import org.appng.core.domain.PackageArchiveImpl;
import org.appng.xml.application.PackageInfo;

import de.skuzzle.semantic.Version;

/**
 * Utility class offering methods that help dealing with {@link PackageVersion}s and {@link PackageInfo}rmations.
 * 
 * @author Matthias Herlitzius
 * 
 */
public class RepositoryUtils {

	/** The {@value #SNAPSHOT}-suffix */
	public static final String SNAPSHOT = "-SNAPSHOT";

	/**
	 * Returns the JAXB context-path {@code org.appng.core.xml.repository}.
	 * 
	 * @return the context-path
	 */
	public static String getContextPath() {
		return org.appng.core.xml.repository.ObjectFactory.class.getPackage().getName();
	}

	/**
	 * Checks whether {@code versionA} is newer than {@code versionB}
	 * 
	 * @param versionA
	 * @param versionB
	 * @return {@code true} if {@code versionA} is newer than {@code versionB}, {@code false} otherwise
	 * @see #isNewer(PackageInfo, PackageInfo)
	 */
	public static boolean isNewer(PackageVersion versionA, PackageVersion versionB) {
		if (null == versionB) {
			return true;
		} else {
			return isNewer(versionA.getPackageInfo(), versionB.getPackageInfo());
		}
	}

	/**
	 * Checks whether {@code packageA} is newer than {@code packageB}. Comparison is first done by the version and then
	 * by the timestamp of the {@link PackageInfo}.
	 * 
	 * @param packageA
	 * @param packageB
	 * @return {@code true} if {@code packageA} is newer than {@code packageB}, {@code false} otherwise
	 * @see #getDate(PackageInfo)
	 */
	public static boolean isNewer(PackageInfo packageA, PackageInfo packageB) {
		if (null == packageB) {
			return true;
		} else {
			String versionA = packageA.getVersion() + "-" + packageA.getTimestamp();
			String versionB = packageB.getVersion() + "-" + packageB.getTimestamp();
			int versionCompare = 0;
			if (Version.isValidVersion(versionA) && Version.isValidVersion(versionB)) {
				versionCompare = Version.parseVersion(versionB, true).compareTo(Version.parseVersion(versionA, true));
				return 0 > versionCompare;
			} else {
				Long timestampA = getDate(packageA).getTime();
				Long timestampB = getDate(packageB).getTime();
				versionCompare = StringUtils.compare(packageB.getVersion(), packageA.getVersion());
				return (0 == versionCompare) ? (timestampA > timestampB) : (0 > versionCompare);
			}
		}
	}

	/**
	 * Retrieves the {@link Date} from the given {@link PackageInfo} by parsing its timestamp
	 * 
	 * @param packageInfo
	 *            the {@link PackageInfo}
	 * @return the date (never {@code null}, in case of a {@link ParseException}, the "zero-time" is used)
	 */
	public static Date getDate(PackageInfo packageInfo) {
		try {
			return new SimpleDateFormat("yyyyMMdd-HHmm").parse(packageInfo.getTimestamp());
		} catch (ParseException e) {
			return new Date(0L);
		}
	}

	/**
	 * Check whether the given name represent a snapshot version
	 * 
	 * @param name
	 *            the name
	 * @return {@code true} if the given name contains {@value #SNAPSHOT}, {@code false} otherwise
	 */
	public static boolean isSnapshot(String name) {
		return name.contains(SNAPSHOT);
	}

	private RepositoryUtils() {
	}

	/**
	 * Checks whether the given file is a valid {@link PackageArchive} and matches to {@link RepositoryMode} of the
	 * {@link Repository}.
	 * 
	 * @param repo
	 *            the {@link Repository}
	 * @param file
	 *            the file containing the archive
	 * @param archiveName
	 *            the name of the archive
	 * @return the {@link PackageArchive}, if the given file is a valid archive and matches the {@link RepositoryMode}
	 *         of the {@link Repository}.
	 */
	public static PackageArchive getPackage(Repository repo, File file, String archiveName) {
		PackageArchive packageArchive = new PackageArchiveImpl(file, archiveName);
		boolean isvalid = packageArchive.isValid();
		if (isvalid) {
			PackageInfo packageInfo = packageArchive.getPackageInfo();
			boolean isSnapshot = isSnapshot(packageInfo.getVersion());
			switch (repo.getRepositoryMode()) {
			case SNAPSHOT:
				isvalid = isSnapshot;
				break;
			case STABLE:
				isvalid = !isSnapshot;
				break;
			default:
				break;
			}
			if (isvalid) {
				return packageArchive;
			}
		}
		return null;
	}

}
