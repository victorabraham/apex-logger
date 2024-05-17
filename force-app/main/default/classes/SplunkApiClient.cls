//Sample for external log writing using postman echo class
//Common auth patterns, token caching, error handling etc can be inherited from a generic ApiClient parent class
public with sharing class SplunkApiClient {
    //Use named credentials for auth if possible
    private static final String SPLUNK_ENDPOINT = 'https://postman-echo.com/post';

    public static String sendLogs(String body) {
        HttpResponse response = execute('POST', SPLUNK_ENDPOINT, null, body);
        System.debug(response.getStatusCode());
        return response.getBody();
    }

    private static HttpResponse execute(String method, String endpoint, Map<String, String> headers, String body) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(SPLUNK_ENDPOINT);
        request.setMethod(method);
        if (headers != null) {
            for (String key : headers.keySet()) {
                request.setHeader(key, headers.get(key));
            }
        }

        if (body != null) {
            request.setBody(body);
        }
        HttpResponse response = new Http().send(request);

        return response;
    }
}