//Jucelio Moura - juceliusdevelop@gmail.com
//https://www.youtube.com/channel/UCMDXBe5-lrP-T-molp2cSBg/videos

unit dtrello.authenticator;

interface

uses
  System.SysUtils, System.Classes;

type
  TAuthenticator = class(TComponent)
  private
    FKey: string;
    FToken: string;
    FUser: string;
    FId: string;
    procedure SetKey(const Value: string);
    procedure SetToken(const Value: string);
    procedure SetUser(const Value: string);
    procedure SetId(const Value: string);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    property Id: string read FId write SetId;
  published
    { Published declarations }
    property User: string read FUser write SetUser;
    property Key: string read FKey write SetKey;
    property Token: string read FToken write SetToken;
  end;

procedure Register;

implementation

{$R ..\Organizations.dcr}

procedure Register;
begin
  RegisterComponents('DTrello', [TAuthenticator]);
end;

{ TAuthenticator }

procedure TAuthenticator.SetId(const Value: string);
begin
  FId := Value;
end;

procedure TAuthenticator.SetKey(const Value: string);
begin
  FKey := Value;
end;

procedure TAuthenticator.SetToken(const Value: string);
begin
  FToken := Value;
end;

procedure TAuthenticator.SetUser(const Value: string);
begin
  FUser := Value;
end;

end.
