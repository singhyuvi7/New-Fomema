var BiometricService = (function () {

	var Type = null;
	var Url = null;
	var Data = null;
	var ContentType = null;
	var DataType = null;
	var ProcessData = null;
	var method = null;
	var result = null;
	var InitResult = null;
	var ScanResult = null;
	var config = null;
	var deviceInfoUrl = null;
	var getQualityThresholdUrl = null;
	var startScanUrl = null;
	var xhr;
	var asyncValue;
	var timeoutValue;
	var getQualityThresholdResult = null;

	var CreateCORSRequest =	function (method, url) {
	  var xhr = new XMLHttpRequest();
	  if ("withCredentials" in xhr) {
	    // XHR for Chrome/Firefox/Opera/Safari.
	    xhr.open(method, url, true);
	  } else if (typeof XDomainRequest != "undefined") {
	    // XDomainRequest for IE.
	    xhr = new XDomainRequest();
	    xhr.open(method, url);
	  } else {
	    // CORS not supported.
	    xhr = null;
	  }
	  return xhr;
	};

	var CallService = function () {
  	$.ajax({
  			headers: {
			'Accept': 'application/json',
			'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
			},
	        type: Type, //GET or POST or PUT or DELETE verb
		    url: Url, // Location of the service
		    xhrFields: {
			    // The 'xhrFields' property sets additional fields on the XMLHttpRequest.
			    // This can be used to set the 'withCredentials' property.
			    // Set the value to 'true' if you'd like to pass cookies to the server.
			    // If this is enabled, your server must respond with the header
			    // 'Access-Control-Allow-Credentials: true'.
			    withCredentials: false
			  },
			async: asyncValue,
			timeout: timeoutValue,
			jsonppCallback: 'callback',
		    contentType: ContentType, // content type sent to server
		    dataType: DataType, //Expected data format from server
		    processdata: ProcessData, //True or False
		    success: function (response) {//On Successfull service call
		        result = response;
				return result;
		    },
		    error: function (jqXHR, textStatus, errorThrown){
		    	if(textStatus==="timeout") {
		            console.log("CallService() : got timeout");
		        }
				result = null;
			}// When Service call fails
	    });
	};

	var GetServiceForQualityThreshold = function () {
  	$.ajax({
  			headers: {
			'Accept': 'application/json',
			'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
			},
	        type: Type, //GET or POST or PUT or DELETE verb
		    url: Url, // Location of the service
		    xhrFields: {
			    // The 'xhrFields' property sets additional fields on the XMLHttpRequest.
			    // This can be used to set the 'withCredentials' property.
			    // Set the value to 'true' if you'd like to pass cookies to the server.
			    // If this is enabled, your server must respond with the header
			    // 'Access-Control-Allow-Credentials: true'.
			    withCredentials: false
			  },
			async: asyncValue,
			timeout: timeoutValue,
			beforeSend: function () {
            	console.log("run StartScan first before get qualityThreshold request complete");
        	},
			jsonppCallback: 'callback',
		    contentType: ContentType, // content type sent to server
		    dataType: DataType, //Expected data format from server
		    processdata: ProcessData, //True or False
		    success: function (response) {//On Successfull service call
		    	console.log(response);
		    	getQualityThresholdResult = response;
		        //result = response;
				//return result;
		    },
		    error: function (jqXHR, textStatus, errorThrown){
		    	if(textStatus==="timeout") {
		            console.log("GetServiceForQualityThreshold() : got timeout");
		        }
				getQualityThresholdResult = null;
			}// When Service call fails
	    });
	};

	var PostCallService = function () {
  	$.ajax({
			headers: {
			'Accept': 'application/json',
			'Content-Type': 'application/json'
			},
	        type: Type, //GET or POST or PUT or DELETE verb
		    url: Url, // Location of the service
		    data: JSON.stringify(Data), //Data sent to server
			async: false,
			timeout: 3000,
			jsonppCallback: 'callback',
		    contentType: ContentType, // content type sent to server
		    dataType: DataType, //Expected data format from server
		    processdata: ProcessData, //True or False
		    success: function (response) {//On Successfull service call
		    	result = null;
		        result = response;
				return result;
		    },
		    error: function (jqXHR, textStatus, errorThrown){
				if(textStatus==="timeout") {
		            console.log("PostCallService() : got timeout");
		        }
				result = null;
			}// When Service call fails
	    });
	};

	//-----------------------init()--------------------------
	var Init = function (configuration, initCallback){
		config = configuration;
		if (configuration != null){
			if (configuration.doctorCode != null && configuration.doctorCode != ""){
				var ReadDeviceInfo = function () {
					var uesrid = "1";
					Type = "GET";
					Url = properties.deviceInfoURL;
					DataType = "json";
					ContentType = "json";
					ProcessData = false;
					method = "deviceInfo";
					asyncValue = false;
					timeoutValue = configuration.scanDuration;
					CallService();
				};

				ReadDeviceInfo();
				var readDeviceResult = new Object();
				readDeviceResult = result;
				var getQualityThresholdResult = null;
				var GetQualityThreshold = function (){
					var uesrid = "1";
					Type = "GET";
					Url = properties.getQualityThresholdURL;
					DataType = "json";
					ContentType = "json";
					ProcessData = false;
					asyncValue = false;
					method = "getQualityThreshold";
					timeoutValue = configuration.scanDuration;
					getQualityThresholdResult = GetServiceForQualityThreshold();
				}

				GetQualityThreshold();
				//var getQualityThresholdResult = result;

				if (readDeviceResult != null){
					if (readDeviceResult[0].serialno == null){
						InitResult = {
							statusMessage: "Invalid Request: Biometric Device not connected"
						};

						initCallback(InitResult);
					}
					else {
						if (getQualityThresholdResult != null){
							InitResult = {
								serialNumber: readDeviceResult[0].serialno,
								qualityThreshold: getQualityThresholdResult,
								doctorCode: configuration.doctorCode,
								computerName: readDeviceResult[0].pcname,
								macAddress: readDeviceResult[0].mac,
								ipAddress: readDeviceResult[0].ip,
								statusMessage: "success"
							}
						}
						else {
							InitResult = {
								serialNumber: readDeviceResult[0].serialno,
								qualityThreshold: configuration.defaultThreshold,
								doctorCode: configuration.doctorCode,
								computerName: readDeviceResult[0].pcname,
								macAddress: readDeviceResult[0].mac,
								ipAddress: readDeviceResult[0].ip,
								statusMessage: "success"
							}
						}
					}
				}
				else {
					InitResult = {
						statusMessage: "Internal Error in Init().ReadDeviceInfo"
					};

					initCallback(InitResult);
				}

				console.log(InitResult);
				if (initCallback != null){
					initCallback(InitResult);
				}
			}
			else{
				InitResult = {
					statusMessage: "Invalid Request: 'configuration.doctorCode' is null"
				};

				initCallback(InitResult);
			}
		}
		else {
			InitResult = {
				statusMessage: "Invalid Request: 'configuration' object is null"
			};

			initCallback(InitResult);
		}
	};

	//-----------------------getInitResult()--------------------------
	var GetInitResult = function (){
		if (InitResult != null){
			return InitResult;
		}
		else {
			InitResult = {
				statusMessage: "Invalid Request: Please run Init() first"
			};
			return InitResult;
		}
	};

	//-----------------------scan()--------------------------
	var Scan = function (successCallback, failureCallback){

		if (InitResult != null && config != null){
			if (InitResult.serialNumber == null){
				ScanResult = {
					statusMessage: "Invalid Request: Device Serial Number NULL. Please make sure device is connected and run Init() again"
				};

				failureCallback(ScanResult);
			}
			else{
				var StartScan = function () {
					var usesrid = "1";
					Type = "POST";
					Url = properties.startScanURL;
					DataType = "json";
					ContentType = "json";
					ProcessData = false;
					method = "StartScan";
					var liveness = false;
					if (config.enableLiveness == 'Y'){
						liveness = true;
					}
					else if(config.enableLiveness == 'N'){
						liveness = false;
					}
					Data = {
						liveness : liveness,
 						timeout : config.scanDuration
					}
					PostCallService();
				};

				StartScan();
				var scanningResult = null;
				scanningResult = result;

				var liveness = null;

				liveness = parseFloat(liveness).toFixed(2);

				if (scanningResult != null){
					if (config.enableLiveness == 'Y'){
						liveness = scanningResult[0].score;
					}
					else {
						liveness = 0.0;
					}

					if (scanningResult[0].status == "Device not detected."){
						ScanResult = {
							statusMessage: "Invalid Request: Device not detected. Please connect biometric device"
						};

						failureCallback(ScanResult);
					}
					console.log(scanningResult[0].score);
					if (getQualityThresholdResult != null){
						if (scanningResult[0].score > getQualityThresholdResult){
							ScanResult = {
								serialNumber: InitResult.serialNumber,
								doctorCode: config.doctorCode,
								computerName: InitResult.computerName,
								macAddress: InitResult.macAddress,
								ipAddress: InitResult.ipAddress,
								fpThumbnail: scanningResult[0].image,
								fpData: scanningResult[0].minutaea,
								fpScore: scanningResult[0].score,
								fpLiveness: liveness,
								statusMessage: "success"
							};
							console.log(ScanResult);

							successCallback(ScanResult);
						}
						else {
							ScanResult = {
								serialNumber: InitResult.serialNumber,
								doctorCode: config.doctorCode,
								computerName: InitResult.computerName,
								macAddress: InitResult.macAddress,
								ipAddress: InitResult.ipAddress,
								fpThumbnail: scanningResult[0].image,
								fpData: scanningResult[0].minutaea,
								fpScore: scanningResult[0].score,
								fpLiveness: liveness,
								statusMessage: "Fingerprint quality score below threshold (" + getQualityThresholdResult + ") :" + scanningResult[0].score
							};

							failureCallback(ScanResult);
						}
					}
					else {
						if (scanningResult[0].score > InitResult.qualityThreshold){
							ScanResult = {
								serialNumber: InitResult.serialNumber,
								doctorCode: config.doctorCode,
								computerName: InitResult.computerName,
								macAddress: InitResult.macAddress,
								ipAddress: InitResult.ipAddress,
								fpThumbnail: scanningResult[0].image,
								fpData: scanningResult[0].minutaea,
								fpScore: scanningResult[0].score,
								fpLiveness: liveness,
								statusMessage: "success"
							};
							console.log(ScanResult);

							successCallback(ScanResult);
						}
						else {
							ScanResult = {
								serialNumber: InitResult.serialNumber,
								doctorCode: config.doctorCode,
								computerName: InitResult.computerName,
								macAddress: InitResult.macAddress,
								ipAddress: InitResult.ipAddress,
								fpThumbnail: scanningResult[0].image,
								fpData: scanningResult[0].minutaea,
								fpScore: scanningResult[0].score,
								fpLiveness: liveness,
								statusMessage: "Fingerprint quality score below threshold (" + InitResult.qualityThreshold + ") :" + scanningResult[0].score
							};

							failureCallback(ScanResult);
						}
					}
				}
				else {
					ScanResult = {
						statusMessage: "Internal Error in Scan().StartScan"
					};

					failureCallback(ScanResult);
				}
			}
		}
		else {
			ScanResult = {
				statusMessage: "Invalid Request: Please run Init() first"
			};

			failureCallback(ScanResult);
		}
	};

	//-----------------------getScanResult()--------------------------
	var GetScanResult = function (){
		if (ScanResult != null){
			return ScanResult;
		}
		else {
			ScanResult = {
				statusMessage: "Invalid Request: Please run Scan() first"
			};
			return ScanResult;
		}
	}

	//--------------------List of Available Function------------------
	return {
		init: Init,
		getInitResult: GetInitResult,
		scan: Scan,
		getScanResult: GetScanResult
	}

})();
