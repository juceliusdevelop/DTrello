unit trello.core;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.JSON, REST.Client, IPPeerCommon, IndyPeerImpl,
  dtrello.authenticator, REST.Types;

type
  Itrello_core = interface
  ['{BAE0C7AA-92E1-4182-855E-001DAA600107}']
    function GetEndPoint: string;
    procedure SetEndPoint(const Value: string);

    property EndPoint: string read GetEndPoint write SetEndPoint;
  end;

  Ttrello_base = class(TInterfacedObject, Itrello_core)
  private
    FEndPoint: string;
    FAuthenticator: TAuthenticator;
    procedure SetAuthenticator(const Value: TAuthenticator);

    function GetEndPoint: string;
    procedure SetEndPoint(const Value: string);
    procedure SetId(AAuthenticator: TAuthenticator);
  public
    constructor Create(const AAuthenticator: TAuthenticator); virtual;
    destructor Destroy; override;

    //Itrello_core
    property EndPoint: string read GetEndPoint write SetEndPoint;

    function Request(const ARequestMethod: TRESTRequestMethod;
                     const AUrl: string;
                     const AParams: array of TJSONPair): TRESTResponse;

    property Authenticator: TAuthenticator read FAuthenticator write SetAuthenticator;
  end;

implementation
  uses System.StrUtils, trello.restclient,
       trello.restrequest, trello.restresponse, REST.Authenticator.OAuth,
       System.Threading, trello.constants, trello.authenticator,
       FireDAC.Comp.Client, trello.util;

{ Ttrello_base }

constructor Ttrello_base.Create(const AAuthenticator: TAuthenticator);
begin
  inherited Create;
  if FAuthenticator = nil then
    FAuthenticator:= TAuthenticator.Create(nil);

  FAuthenticator.User:= AAuthenticator.User;
  FAuthenticator.Key:= AAuthenticator.Key;
  FAuthenticator.Token:= AAuthenticator.Token;
  SetId(FAuthenticator);
end;

destructor Ttrello_base.Destroy;
begin
  if FAuthenticator <> nil then
    FreeAndNil(FAuthenticator);
  inherited;
end;

function Ttrello_base.GetEndPoint: string;
begin
  Result:= FEndPoint;
end;

function Ttrello_base.Request(const ARequestMethod: TRESTRequestMethod;
                     const AUrl: string;
                     const AParams: array of TJSONPair): TRESTResponse;
var
  loRESTClient: TRESTClient;
  loOAuth1Authenticator: TOAuth1Authenticator;
  loRESTRequest: TRESTRequest;
begin
  Result:= nil;
  try
    loRESTClient:= Ttrello_restclient.Instance.RestClient;
    loRESTClient.BaseURL:= AUrl;
    loOAuth1Authenticator:= Ttrello_authenticator.Instance.Authenticator(
      Authenticator.Token, Authenticator.Key, Authenticator.User);
    loRESTClient.Authenticator:= loOAuth1Authenticator;
    Result:= Ttrello_restresponse.Instance.RestResponse;
    loRESTRequest:= Ttrello_restrequest.Instance.RestClient(AParams);
    loRESTRequest.Method:= ARequestMethod;
    loRESTRequest.Client:= loRESTClient;
    loRESTRequest.Response:= Result;
    loRESTRequest.Execute;
  except
    raise;
  end;
end;

procedure Ttrello_base.SetAuthenticator(const Value: TAuthenticator);
begin
  FAuthenticator := Value;
end;

procedure Ttrello_base.SetEndPoint(const Value: string);
begin
  FEndPoint:= Value;
end;

procedure Ttrello_base.SetId(AAuthenticator: TAuthenticator);
var
  loTable: TFDMemTable;
begin
  loTable:= TFDMemTable.Create(nil);
  try
    loTable.DataInJson(
    Request(TRESTRequestMethod.rmGET,
          Format('%s/members/%s', [TDTrelloContants.BaseUrl, AAuthenticator.User]),
          []));
    AAuthenticator.Id:= loTable.FieldByName('id').AsString;
  finally
    FreeAndNil(loTable);
  end;
end;

end.
