const updateConsentState = require('updateConsentState');
const queryPermission = require('queryPermission');
const setDefaultConsentState = require('setDefaultConsentState');
const getCookieValues = require('getCookieValues');
const callInWindow = require('callInWindow');
const createQueue = require('createQueue');
const dataLayerPush = createQueue('dataLayer');
const logToConsole = require('logToConsole');
var userPreferences;

let consentOptions = {
'ad_storage' : 'denied',
'analytics_storage' : 'denied',
'functionality_storage' : 'denied',
'personalization_storage' : 'denied',
'security_storage':  'granted',
'wait_for_update' : 500
};

// If consent already exists, update the consent
if( getCookieValues('amcookie_allowed').toString() !== '' ) {

userPreferences = getCookieValues("amcookie_allowed")[0];
userPreferences = (userPreferences == 0) ? "1,2,3" : userPreferences;
userPreferences = userPreferences.split(',');

userPreferences.forEach( (consent) => {
switch(consent){
case "1":
consentOptions.ad_storage = 'granted';
consentOptions.personalization_storage = 'granted';
break;
case "2":
consentOptions.analytics_storage = 'granted';
break;
case "3":
consentOptions.functionality_storage = 'granted';
break;
}
});

}

// Set default consent state.
setDefaultConsentState(consentOptions);

// Update consent once user selects options
const processConsentObject = (consentOptions) => {

const consent = {
ad_storage: consentOptions.ad_storage,
analytics_storage: consentOptions.analytics_storage,
functionality_storage: consentOptions.functionality_storage,
personalization_storage: consentOptions.personalization_storage,
security_storage: 'granted'
};

updateConsentState(consent);
dataLayerPush( {'event': 'gtm.init'} );
};

callInWindow('addConsentListener', processConsentObject);

data.gtmOnSuccess();
