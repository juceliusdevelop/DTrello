unit trello.authenticator;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  REST.Authenticator.OAuth;

type
  TTrelloOAuth1Authenticator = class(TOAuth1Authenticator)
  private
    FAccessUser: string;
    procedure SetAccessUser(const Value: string);
  public
    property AccessUser: string read FAccessUser write SetAccessUser;
  end;

  Ttrello_authenticator = class(TComponent)
  private
    class var _Authenticator: Ttrello_authenticator;
  public
    class function Instance: Ttrello_authenticator;

    function Authenticator(const
      AAccessToken, AConsumerKey, AAccessUser: string): TTrelloOAuth1Authenticator;
  end;

implementation

{ Ttrello_authenticator }

function Ttrello_authenticator.authenticator(const AAccessToken,
  AConsumerKey, AAccessUser: string): TTrelloOAuth1Authenticator;
begin
  Result:= TTrelloOAuth1Authenticator.Create(Self);
  Result.AccessToken:= AAccessToken;
  Result.ConsumerKey:= AConsumerKey;
  Result.AccessUser:= AAccessUser;
end;

class function Ttrello_authenticator.Instance: Ttrello_authenticator;
begin
  if (_Authenticator = nil) then
    _Authenticator := Ttrello_authenticator.Create(nil);
  Result := _Authenticator;
end;

{ TTrelloOAuth1Authenticator }

procedure TTrelloOAuth1Authenticator.SetAccessUser(const Value: string);
begin
  FAccessUser := Value;
end;

initialization
  Ttrello_authenticator._Authenticator := nil;

finalization
  if (Ttrello_authenticator._Authenticator <> nil) then
    FreeAndNil(Ttrello_authenticator._Authenticator);

end.
