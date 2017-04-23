unit trello.request;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  REST.Client, system.JSON, REST.Types, trello.core, dtrello.authenticator;

type
  Ttrello_request = class
  private
    class var _Request: Ttrello_request;
  public
    class function Instance: Ttrello_request;

    procedure Request(Authenticator: TAuthenticator; const Url: string);
  end;

{ Ttrello_request }
implementation
  uses trello.authenticator, trello.restclient,
  trello.restrequest, trello.restresponse, REST.Authenticator.OAuth;

class function Ttrello_request.Instance: Ttrello_request;
begin
  if (_Request = nil) then
    _Request := Ttrello_request.Create;
  Result := _Request;
end;

procedure Ttrello_request.Request(Authenticator: TAuthenticator; const Url: string);
var
  loRESTClient: TRESTClient;
  loOAuth1Authenticator: TOAuth1Authenticator;
  loRESTResponse: TRESTResponse;
  loRESTRequest: TRESTRequest;
begin
  loRESTClient:= Ttrello_restclient.Instance.RestClient;
  loRESTClient.BaseURL:= Url;
  loOAuth1Authenticator:= Ttrello_authenticator.Instance.Authenticator(
    Authenticator.Token, Authenticator.Key, Authenticator.User);
  loRESTClient.Authenticator:= loOAuth1Authenticator;
  loRESTResponse:= Ttrello_restresponse.Instance.RestResponse;
  loRESTRequest:= Ttrello_restrequest.Instance.RestClient([]);
  loRESTRequest.Client:= loRESTClient;
  loRESTRequest.Response:= loRESTResponse;
  loRESTRequest.Execute;
end;

initialization
  Ttrello_request._Request := nil;

finalization
  if (Ttrello_request._Request <> nil) then
    FreeAndNil(Ttrello_request._Request);

end.
