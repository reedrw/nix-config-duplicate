{ config, lib, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    font = "scientifica 8";
    theme = with config.lib.base16.theme; builtins.toFile "theme.rasi" ''
      * {
          active-background: #${base00-hex};
          active-foreground: @foreground;
          normal-background: @background;
          normal-foreground: @foreground;
          urgent-background: #${base08-hex};
          urgent-foreground: @foreground;

          alternate-active-background: @background;
          alternate-active-foreground: @foreground;
          alternate-normal-background: @background;
          alternate-normal-foreground: @foreground;
          alternate-urgent-background: @background;
          alternate-urgent-foreground: @foreground;

          selected-active-background: #${base00-hex};
          selected-active-foreground: @foreground;
          selected-normal-background: #${base01-hex};
          selected-normal-foreground: @foreground;
          selected-urgent-background: #${base03-hex};
          selected-urgent-foreground: @foreground;

          background-color: @background;
          background: #${base00-hex};
          foreground: #${base07-hex};
          border-color: @background;
          spacing: 4;
      }

      #window {
          background-color: @background;
          border: 0;
          padding: 2.5ch;
      }

      #mainbox {
          border: 0;
          padding: 0;
      }

      #message {
          border: 2px 0px 0px;
          border-color: @border-color;
          padding: 1px;
      }

      #textbox {
          text-color: @foreground;
      }

      #listview {
          fixed-height: 0;
          border: 2px 0px 0px;
          border-color: @border-color;
          spacing: 2px;
          scrollbar: true;
          padding: 2px 0px 0px;
      }

      #element {
          border: 0;
          padding: 1px;
      }

      #element.normal.normal {
          background-color: @normal-background;
          text-color: @normal-foreground;
      }

      #element.normal.urgent {
          background-color: @urgent-background;
          text-color: @urgent-foreground;
      }

      #element.normal.active {
          background-color: @active-background;
          text-color: @active-foreground;
      }

      #element.selected.normal {
          background-color: @selected-normal-background;
          text-color: @selected-normal-foreground;
      }

      #element.selected.urgent {
          background-color: @selected-urgent-background;
          text-color: @selected-urgent-foreground;
      }

      #element.selected.active {
          background-color: @selected-active-background;
          text-color: @selected-active-foreground;
      }

      #element.alternate.normal {
          background-color: @alternate-normal-background;
          text-color: @alternate-normal-foreground;
      }

      #element.alternate.urgent {
          background-color: @alternate-urgent-background;
          text-color: @alternate-urgent-foreground;
      }

      #element.alternate.active {
          background-color: @alternate-active-background;
          text-color: @alternate-active-foreground;
      }

      #scrollbar {
          width: 4px;
          border: 0;
          handle-width: 8px;
          padding: 0;
      }

      #sidebar {
          border: 2px 0px 0px;
          border-color: @border-color;
      }

      #button.selected {
          background-color: @selected-normal-background;
          text-color: @selected-normal-foreground;
      }

      #inputbar {
          spacing: 5;
          text-color: @normal-foreground;
          padding: 1px;
      }

      #case-indicator {
          spacing: 0;
          text-color: @normal-foreground;
      }

      #entry {
          spacing: 1px;
          text-color: @normal-foreground;
      }

      #prompt {
          spacing: 0;
          text-color: @normal-foreground;
      }
    '';
  };
}

