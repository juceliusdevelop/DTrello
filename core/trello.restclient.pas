unit trello.restclient;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  REST.Client;

type
  Ttrello_restclient = class(TComponent)
  private
    class var _RestClient: Ttrello_restclient;
  public
    class function Instance: Ttrello_restclient;

    function RestClient: TRESTClient;
  end;

implementation

{ Ttrello_restclient }

class function Ttrello_restclient.Instance: Ttrello_restclient;
begin
  if (_RestClient = nil) then
    _RestClient := Ttrello_restclient.Create(nil);
  Result := _RestClient;
end;

function Ttrello_restclient.RestClient: TRESTClient;
begin
  Result:= TRESTClient.Create(self);
  Result.Accept:= 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  Result.AcceptCharset:= 'UTF-8, *;q=0.8';
  Result.HandleRedirects:= True;
  Result.RaiseExceptionOn500:= False;
end;

initialization
  Ttrello_restclient._RestClient := nil;

finalization
  if (Ttrello_restclient._RestClient <> nil) then
    FreeAndNil(Ttrello_restclient._RestClient);

end.
