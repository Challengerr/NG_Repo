/**
 * Created by jeziorem on 01.09.2019.
 */

public with sharing class NG_ImageCallout {
    public static final String endpointURL = 'https://jsonplaceholder.typicode.com/photos';

    public static void fetchImages() {
        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint(endpointURL);
        httpRequest.setMethod('GET');
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setHeader('Accept', 'application/json');
        HttpResponse response = http.send(httpRequest);

        List<NG_ImageCalloutWrapper> imaeList = (List<NG_ImageCalloutWrapper>) JSON.deserialize(response.getBody(), List<NG_ImageCalloutWrapper>.class);
        System.debug(imaeList);
        List<NG_Image_Shelf__c> imagesToInsert = new List<NG_Image_Shelf__c>();
        List<NG_Image_Shelf__c> existiNgImageShelve = [SELECT Id, AlbumId__c FROM NG_Image_Shelf__c];
        List<NG_Image_Shelf__c> toDeleteImages = new List<NG_Image_Shelf__c>();
        Map<Decimal, NG_Image_Shelf__c> albumToImgMap = new Map<Decimal, NG_Image_Shelf__c>();
        for (NG_Image_Shelf__c image : existiNgImageShelve) {
            albumToImgMap.put(image.AlbumId__c, image);
        }
        for (NG_ImageCalloutWrapper img : imaeList) {
            NG_Image_Shelf__c ngImage = new NG_Image_Shelf__c();
            ngImage.AlbumId__c = img.albumId;
            ngImage.Thumbnail_Url__c = img.thumbnailUrl;
            ngImage.Title__c = img.title;
            ngImage.Url__c = img.url;

            if (!existiNgImageShelve.isEmpty() && !albumToImgMap.keySet().contains(ngImage.AlbumId__c)) {
                toDeleteImages.add(albumToImgMap.get(ngImage.AlbumId__c));
            } else {
                imagesToInsert.add(ngImage);
            }
        }
        upsert imagesToInsert;
        delete toDeleteImages;
    }
}