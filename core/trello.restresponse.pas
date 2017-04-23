unit trello.restresponse;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  REST.Client, system.JSON, REST.Types;

type
  Ttrello_restresponse = class(TComponent)
  private
    class var _RestResponse: Ttrello_restresponse;
  public
    class function Instance: Ttrello_restresponse;

    function RestResponse: TRESTResponse;
  end;

implementation

{ Ttrello_restresponse }

class function Ttrello_restresponse.Instance: Ttrello_restresponse;
begin
  if (_RestResponse = nil) then
    _RestResponse := Ttrello_restresponse.Create(nil);
  Result := _RestResponse;
end;

function Ttrello_restresponse.RestResponse: TRESTResponse;
begin
  Result:= TRESTResponse.Create(Self);
  Result.ContentType:= 'application/json';
end;

initialization
  Ttrello_restresponse._RestResponse := nil;

finalization
  if (Ttrello_restresponse._RestResponse <> nil) then
    FreeAndNil(Ttrello_restresponse._RestResponse);

end.
