const updateConsentState = require('updateConsentState');
const setDefaultConsentState = require('setDefaultConsentState');
const getCookieValues = require('getCookieValues');
const callInWindow = require('callInWindow');
const createQueue = require('createQueue');
const dataLayerPush = createQueue('dataLayer');

// Cookie named used by Amasty module
const COOKIE_NAME = 'amcookie_allowed';

let stateObject = {
    'ad_storage' : 'denied',
    'ad_user_data' : 'denied',
    'ad_personalization' : 'denied',
    'analytics_storage' : 'denied',
    'functionality_storage' : 'denied',
    'personalization_storage' : 'denied',
    'security_storage' : 'granted'
};

// Convert cookie string into an array
const getUserPreferences = (cookie) => {
    return cookie.split(',');
};

// Convert the selected options from cookie array into a consent object
const convertCookieToOptions = (cookie) => {
    return {
        'ad_storage' : (cookie == 0) ? "granted" : (getUserPreferences(cookie).indexOf("1") >= 0) ? "granted" : "denied",
        'ad_user_data' : (cookie == 0) ? "granted" : (getUserPreferences(cookie).indexOf("1") >= 0) ? "granted" : "denied",
        'ad_personalization' : (cookie == 0) ? "granted" : (getUserPreferences(cookie).indexOf("1") >= 0) ? "granted" : "denied",
        'analytics_storage' : (cookie == 0) ? "granted" : (getUserPreferences(cookie).indexOf("2") >= 0) ? "granted" : "denied",
        'functionality_storage' : (cookie == 0) ? "granted" : (getUserPreferences(cookie).indexOf("3") >= 0) ? "granted" : "denied",
        'personalization_storage' : (cookie == 0) ? "granted" : (getUserPreferences(cookie).indexOf("1") >= 0) ? "granted" : "denied",
        'security_storage':  "granted"
    };
};

// When the user makes a selection, update the consent states
const onUserConsent = (consent) => {
    consent.ad_user_data = "denied";
    consent.ad_personalization = "denied";
    if(consent.ad_storage === "granted"){
        consent.ad_user_data = "granted";
        consent.ad_personalization = "granted";
    }
    updateConsentState(consent);
    dataLayerPush( {'event': 'gtm.init'} );
};

const main = (data) => {
    if (typeof getCookieValues(COOKIE_NAME).length > 0) {
        onUserConsent(convertCookieToOptions(getCookieValues(COOKIE_NAME)[0]));
    } else {
        setDefaultConsentState({
            'ad_storage' : 'denied',
            'ad_user_data' : 'denied',
            'ad_personalization' : 'denied',
            'analytics_storage' : 'denied',
            'functionality_storage' : 'denied',
            'personalization_storage' : 'denied',
            'security_storage' : 'granted'
        });
    }
    callInWindow('addConsentListener', onUserConsent);
};

main(data);
data.gtmOnSuccess();
