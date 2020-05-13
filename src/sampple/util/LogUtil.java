package sampple.util;

import org.apache.log4j.Logger;

public class LogUtil {
	
	private static final Logger logger = Logger.getLogger(LogUtil.class);

	private LogUtil() {
		throw new IllegalStateException("Utility class");
	}

	public static Logger getLogger() {
		return logger;
	}
}
