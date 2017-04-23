unit trello.restrequest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  REST.Client, system.JSON, REST.Types;

type
  Ttrello_restrequest = class(TComponent)
  private
    class var _RestRequest: Ttrello_restrequest;
  public
    destructor Destroy; override;
    class function Instance: Ttrello_restrequest;

    function RestClient(const AParams: array of TJSONPair): TRESTRequest;
  end;

implementation

{ Ttrello_restrequest }

destructor Ttrello_restrequest.Destroy;
begin
  //
  inherited;
end;

class function Ttrello_restrequest.Instance: Ttrello_restrequest;
begin
  if (_RestRequest = nil) then
    _RestRequest := Ttrello_restrequest.Create(nil);
  Result := _RestRequest;
end;

function Ttrello_restrequest.RestClient(
  const AParams: array of TJSONPair): TRESTRequest;
var
  loI: Integer;
begin
  Result:= TRESTRequest.Create(Self);
  Result.SynchronizedEvents:= False;
  for loI := 0 to High(AParams) do
    Result.AddParameter(StringReplace(AParams[loI].JsonString.ToString, '"','', [rfReplaceAll, rfIgnoreCase]),
                        StringReplace(AParams[loI].JsonValue.ToString, '"', '', [rfReplaceAll, rfIgnoreCase]));

  for loI := High(AParams) downto 0 do
    AParams[loI].Free;
end;

initialization
  Ttrello_restrequest._RestRequest := nil;

finalization
  if (Ttrello_restrequest._RestRequest <> nil) then
    FreeAndNil(Ttrello_restrequest._RestRequest);

end.
