//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 18
#property indicator_color1 HotPink
#property indicator_width1 3
#property indicator_color2 HotPink
#property indicator_width2 3
#property indicator_color3 DodgerBlue
#property indicator_width3 3
#property indicator_color4 DodgerBlue
#property indicator_width4 3
#property indicator_color5 HotPink
#property indicator_color6 HotPink
#property indicator_color7 DodgerBlue
#property indicator_color8 DodgerBlue

#property indicator_color9 Red
#property indicator_width9 3
#property indicator_color10 Red
#property indicator_width10 3
#property indicator_color11 Blue
#property indicator_width11 3
#property indicator_color12 Blue
#property indicator_width12 3
#property indicator_color13 Red
#property indicator_color14 Red
#property indicator_color15 Blue
#property indicator_color16 Blue

#property indicator_color17 Blue
#property indicator_color18 Red
//#property icon "Logo TraderVibes (1).ico"
#property copyright "Copyright 2022, Trader Vibes"
#property link      "TraderVibes"
#property version   "1.52"

//=========================================================================================================================||
string   NameAccount    = "abc"; //Ganti nama akun disini. Isi dengan abc jika ingin tanpa lock
long     NomorAccount   = 0; //Ganti nomor account yang diijinkan disini. Isi dengan angka 0 jika ingin tanpa lock account
datetime Expired        = D'15.12.2025';   //Ganti tanggal expired disini
string   LockBroker     = "abc"; //Ganti nama broker disini. Isi dengan abc jika ingin tanpa lock
//=========================================================================================================================||

int Sensitivity = 1;
int term = 30;
int std = 2;
int average_term = 40;
ENUM_MA_METHOD metoda = MODE_SMMA;
ENUM_APPLIED_PRICE rate = PRICE_CLOSE;
bool push_notification = false;
bool activate_allert = false;
string get_code = " ";

int secret_pass = 9873;
string pass_dynamic = AccountNumber()*3.0+secret_pass;

int g_period_80;
int g_period_84;
double g_ibuf_88[];
double g_ibuf_92[];
double g_ibuf_96[];
double g_ibuf_100[];
double g_ibuf_104[];
double g_ibuf_108[];
double g_ibuf_112[];
double g_ibuf_116[];

double g_ibuf_881[];
double g_ibuf_921[];
double g_ibuf_961[];
double g_ibuf_1001[];
double g_ibuf_1041[];
double g_ibuf_1081[];
double g_ibuf_1121[];
double g_ibuf_1161[];

double BufferSignalBuy[];
double BufferSignalSell[];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   ObjectCreate("Close line", OBJ_HLINE, 0, Time[40], Close[0]);
   ObjectSet("Close line", OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet("Close line", OBJPROP_COLOR, DimGray);
   SetIndexStyle(0, DRAW_HISTOGRAM, EMPTY, 3);
   SetIndexBuffer(0, g_ibuf_88);
   SetIndexStyle(1, DRAW_HISTOGRAM, EMPTY, 3);
   SetIndexBuffer(1, g_ibuf_92);
   SetIndexStyle(2, DRAW_HISTOGRAM, EMPTY, 3);
   SetIndexBuffer(2, g_ibuf_96);
   SetIndexStyle(3, DRAW_HISTOGRAM, EMPTY, 3);
   SetIndexBuffer(3, g_ibuf_100);
   SetIndexStyle(4, DRAW_HISTOGRAM, EMPTY, 0);
   SetIndexBuffer(4, g_ibuf_104);
   SetIndexStyle(5, DRAW_HISTOGRAM, EMPTY, 0);
   SetIndexBuffer(5, g_ibuf_108);
   SetIndexStyle(6, DRAW_HISTOGRAM, EMPTY, 0);
   SetIndexBuffer(6, g_ibuf_112);
   SetIndexStyle(7, DRAW_HISTOGRAM, EMPTY, 0);
   SetIndexBuffer(7, g_ibuf_116);

   SetIndexStyle(8, DRAW_HISTOGRAM, EMPTY, 3);
   SetIndexBuffer(8, g_ibuf_881);
   SetIndexStyle(9, DRAW_HISTOGRAM, EMPTY, 3);
   SetIndexBuffer(9, g_ibuf_921);
   SetIndexStyle(10, DRAW_HISTOGRAM, EMPTY, 3);
   SetIndexBuffer(10, g_ibuf_961);
   SetIndexStyle(11, DRAW_HISTOGRAM, EMPTY, 3);
   SetIndexBuffer(11, g_ibuf_1001);
   SetIndexStyle(12, DRAW_HISTOGRAM, EMPTY, 0);
   SetIndexBuffer(12, g_ibuf_1041);
   SetIndexStyle(13, DRAW_HISTOGRAM, EMPTY, 0);
   SetIndexBuffer(13, g_ibuf_1081);
   SetIndexStyle(14, DRAW_HISTOGRAM, EMPTY, 0);
   SetIndexBuffer(14, g_ibuf_1121);
   SetIndexStyle(15, DRAW_HISTOGRAM, EMPTY, 0);
   SetIndexBuffer(15, g_ibuf_1161);

   SetIndexStyle(16,DRAW_ARROW, STYLE_SOLID, 1);
   SetIndexArrow(16, 233);
   SetIndexBuffer(16, BufferSignalBuy);
   SetIndexLabel(16,"Buy");

   SetIndexStyle(17,DRAW_ARROW, STYLE_SOLID, 1);
   SetIndexArrow(17, 234);
   SetIndexBuffer(17, BufferSignalSell);
   SetIndexLabel(17,"Sell");

   IndicatorShortName("NS");
   return (0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("Close line");
   Comment("");
   return (0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {

   if(NameAccount != "abc" && (NameAccount != AccountName() && toUpper(NameAccount) != AccountName() && toLower(NameAccount) != AccountName()))
     {
      Alert("Wrong Name, Activaion Name: ", NameAccount, " MT5 Name: ", AccountName());
      return(0);
     }

   double l_icci_0,
          l_icci_1,
          l_icci_2,
          l_icci_3;

   int li_16;
   ObjectMove("Close line", 0, Time[20], Close[0]);
   if(Sensitivity == 1)
     {
      g_period_84 = 5;
      g_period_80 = 14;
     }
   if(Sensitivity == 0 || Sensitivity == 2 || Sensitivity > 3)
     {
      g_period_84 = 14;
      g_period_80 = 50;
     }
   if(Sensitivity == 3)
     {
      g_period_84 = 89;
      g_period_80 = 200;
     }

   static int gate,
          gate1;

   int arrow_limitBuy = 0, arrow_limitSell = 0;

   static int rsi_gate,
          rsi_gate1;

   static int MC_gate = 0;
   static int MC_gate1 = 0;

   int l_ind_counted_20 = IndicatorCounted();
   if(Bars <= 15)
      return (0);
   if(l_ind_counted_20 < 1)
     {
      for(int li_24 = 1; li_24 <= 15; li_24++)
        {
         g_ibuf_88[Bars - li_24] = 0.0;
         g_ibuf_96[Bars - li_24] = 0.0;
         g_ibuf_92[Bars - li_24] = 0.0;
         g_ibuf_100[Bars - li_24] = 0.0;
         g_ibuf_104[Bars - li_24] = 0.0;
         g_ibuf_112[Bars - li_24] = 0.0;
         g_ibuf_108[Bars - li_24] = 0.0;
         g_ibuf_116[Bars - li_24] = 0.0;
        }
     }
   if(l_ind_counted_20 > 0)
      li_16 = Bars - l_ind_counted_20;
   if(l_ind_counted_20 == 0)
      li_16 = Bars - 15 - 1;
   for(li_24 = li_16; li_24 >= 0; li_24--)
     {
      l_icci_0 = iRSI(NULL,0,10,PRICE_CLOSE,li_24);
      l_icci_1 = iMA(NULL,0,10,0,MODE_SMA,PRICE_CLOSE,li_24);
      l_icci_2 = iMA(NULL,0,30,0,MODE_SMA,PRICE_CLOSE,li_24);
      l_icci_3 = iMA(NULL,0,168,0,MODE_EMA,PRICE_CLOSE,li_24);
      g_ibuf_88[li_24] = EMPTY_VALUE;
      g_ibuf_96[li_24] = EMPTY_VALUE;
      g_ibuf_92[li_24] = EMPTY_VALUE;
      g_ibuf_100[li_24] = EMPTY_VALUE;
      g_ibuf_104[li_24] = EMPTY_VALUE;
      g_ibuf_112[li_24] = EMPTY_VALUE;
      g_ibuf_108[li_24] = EMPTY_VALUE;
      g_ibuf_116[li_24] = EMPTY_VALUE;

      /*if(l_icci_0 < (70))
        {
         gate = 0;
        }
      if(l_icci_0 > (30))
        {
         gate1 = 0;
        }*/

      if(l_icci_0 > 80)
        {
         rsi_gate = 1;
         rsi_gate1 = 0;
         arrow_limitSell = 0;
        }
      if(l_icci_0 < 20)
        {
         rsi_gate = 0;
         rsi_gate1 = 1;
         arrow_limitBuy = 0;
        }

      if(l_icci_0 > 69 && l_icci_0 < 90)
        {
         g_ibuf_88[li_24] = MathMax(Open[li_24], Close[li_24]);
         g_ibuf_92[li_24] = MathMin(Open[li_24], Close[li_24]);
         g_ibuf_104[li_24] = High[li_24];
         g_ibuf_108[li_24] = Low[li_24];
         gate = 1;
         gate1 = 0;
         MC_gate = 0;
        }
      else
        {
         if(l_icci_0 < 31 && l_icci_0 > 10)
           {
            g_ibuf_96[li_24] = MathMax(Open[li_24], Close[li_24]);
            g_ibuf_100[li_24] = MathMin(Open[li_24], Close[li_24]);
            g_ibuf_112[li_24] = High[li_24];
            g_ibuf_116[li_24] = Low[li_24];
            gate = 0;
            gate1 = 1;
            MC_gate1 = 0;
           }
        }

      if(l_icci_0 > 90)
        {
         g_ibuf_881[li_24] = MathMax(Open[li_24], Close[li_24]);
         g_ibuf_921[li_24] = MathMin(Open[li_24], Close[li_24]);
         g_ibuf_1041[li_24] = High[li_24];
         g_ibuf_1081[li_24] = Low[li_24];
         gate = 1;
        }
      else
        {
         if(l_icci_0 < 10)
           {
            g_ibuf_961[li_24] = MathMax(Open[li_24], Close[li_24]);
            g_ibuf_1001[li_24] = MathMin(Open[li_24], Close[li_24]);
            g_ibuf_1121[li_24] = High[li_24];
            g_ibuf_1161[li_24] = Low[li_24];
            gate1 = 1;
           }
        }


      if((Close[li_24] < l_icci_1 && Close[li_24+1] > l_icci_1) && (l_icci_2 < l_icci_3) && gate == 1 && MC_gate == 0)
        {
         BufferSignalSell[li_24] = High[li_24] + 400 * _Point;
         MC_gate = 1;
         arrow_limitSell += 1;
        }

      if((Close[li_24] > l_icci_1 && Close[li_24+1] < l_icci_1) && (l_icci_2 > l_icci_3) && gate1 == 1 && MC_gate1 == 0)
        {
         BufferSignalBuy[li_24] = Low[li_24] - 400 * _Point;
         MC_gate1 = 1;
         arrow_limitBuy += 1;
        }
     }
   return (0);
  }
//+------------------------------------------------------------------+
bool NewBar()
  {
   static datetime lastbar;
   datetime curbar = Time[0];
   if(lastbar!=curbar)
     {
      lastbar=curbar;
      return (true);
     }
   else
     {
      return(false);
     }
  }
//+------------------------------------------------------------------+
string toLower(string text)
  {
   StringToLower(text);
   return text;
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string toUpper(string text)
  {
   StringToUpper(text);
   return text;
  };
//+------------------------------------------------------------------+
