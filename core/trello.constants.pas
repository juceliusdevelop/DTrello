unit trello.constants;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Winapi.Messages;

type
  TDTrelloContants = class
  public
    const
      wm_deletecard = WM_USER + 1;
      BaseUrl = 'https://api.trello.com/1';
  end;

implementation

end.
