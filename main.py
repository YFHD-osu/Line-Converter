#記得授予: python-test@cool-healer-320106.iam.gserviceaccount.com 編輯的權限!
sheet_url = 'https://docs.google.com/spreadsheets/d/17U7FXfIGVBtZGPb-Ndw0W3HPCx9ZBvLh-o1e_QNdlCw/' #表單URL
worksheet1_name = "接車表" #工作表1
worksheet2_name = "體溫表早" #工作表2

import threading
import pygsheets
import datetime
from PyQt5 import QtWidgets
from UI import Ui_MainWindow
import time

 #Windows User Only
# try:
#     import ctypes
#     myappid = 'mycompany.myproduct.subproduct.version' # arbitrary string
#     ctypes.windll.shell32.SetCurrentProcessExplicitAppUserModelID(myappid)
# except: pass
# try: ctypes.windll.user32.ShowWindow( ctypes.windll.kernel32.GetConsoleWindow(), 0 )
# except: pass

class MainWindow_controller(QtWidgets.QMainWindow):
    def __init__(self):
        super().__init__() # in python3, super(Class, self).xxx = super().xxx
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)
        self.ui.ExitButton.clicked.connect(self.exit_btn)
        self.ui.Process.clicked.connect(self.process_btn)
        self.database = {}
        self.usetime = 0

        self.setup_control()

    def setup_control(self):
        pass

    def closeEvent(self, event):
        sys.exit()

    def exit_btn(self):
        sys.exit()
            
    def process_btn(self):
        self.usetime = time.time()
        threads =  threading.Thread(target = self.prase_string)
        threads.daemon = True
        threads.start()
    
    def prase_string(self):
        self.ui.Status_Text.setText("讀取中...")
        message = [self.ui.Car_ID.toPlainText(), self.ui.Person_ID.toPlainText()]
        message[0] = message[0].replace(" ","")
        message[1] = message[1].replace(" ","")

        car_id_list = message[0].split("\n")
        person_car = message[1].split("\n")
        car_id_list.append("")

        try:
            i = 0
            while True:
                if i > (len(car_id_list) - 1):
                    # print(":!")
                    break

                tmp_data = car_id_list[i].split("車")

                # print(i)
                if "午" in car_id_list[i]:
                    if not ("車" in car_id_list[i+1]) and (car_id_list[i+1] != ""):
                        self.database[f"{tmp_data[0]}"] = {"Come_ID": tmp_data[1].split("午")[1],"Leave_ID": car_id_list[i+1].split("午")[1]}
                        i += 2
                    else:
                        self.database[f"{tmp_data[0]}"] = {"Come_ID": None, "Leave_ID": tmp_data[1].split("午")[1]}
                        i += 1
                else:
                    if tmp_data[0] != "":
                        self.database[f"{tmp_data[0]}"] = {"Come_ID": tmp_data[1], "Leave_ID": tmp_data[1]} 
                    i += 1

            while True:
                try: person_car.remove("")
                except: break
            i = 0
            # print(len(person_car) - 1)

            # timeout = time.time() + 5   # 5 seconds from now
            while True:
                # if time.time() > timeout: break
                if i > (len(person_car) - 1): break
                if "車" in person_car[i]:
                    tmp_data = person_car[i].split("車")
                    # print(tmp_data)
                    tmp_list = []
                    for name in person_car[i+1].split("，"):
                        tmp_list.append([name])
                    if len(tmp_list) < 4:
                        for k in range(0,4-len(tmp_list)):
                            tmp_list.append((['---']))
                    if "來" in tmp_data[1]:
                        self.database[f"{tmp_data[0]}"]["Come_Person"] = tmp_list
                    if "回" in tmp_data[1]:
                        self.database[f"{tmp_data[0]}"]["Leave_Person"] = tmp_list
                    i += 2
                else: i += 1
        except: 
            self.ui.Status_Text.setText("錯誤!(請檢查訊息的位置是否貼反了)")
            return

        thread0 =  threading.Thread(target = self.auth)
        thread0.daemon = True
        thread0.start()
        thread0.join()

        thread1 = threading.Thread(target = self.write_sheet1_data)
        thread1.daemon = True
        thread1.start()

        thread2 = threading.Thread(target = self.write_sheet2_data, args=(thread1,))
        thread2.daemon = True
        thread2.start()

    def auth(self):
        self.ui.Status_Text.setText("憑證連線中...")
        self.client = pygsheets.authorize(service_file='auth.json')
        return

    def write_sheet1_data(self):
        sht = self.client.open_by_url(sheet_url)
        sheet = sht.worksheet_by_title(worksheet1_name)

        car_row = ['A','C','E','A','C','E','A','C','E','H','J','L']
        name_row = ['B','D','F','B','D','F','B','D','F','I','K','M']
        lan = [2,2,2,6,6,6,10,10,10,2,2,2,6,6,6,10,10,10]
        CAR_index_num = 0

        weekday = ["一","二","三","四","五","六","日","一"]

        write_matrix = {'cells':[], 'values':[]}
        
        #更新日期
        write_matrix['cells'].append('A1:A1')
        write_matrix['values'].append([[f'{str(datetime.date.today() + datetime.timedelta(days=1)).replace("-","/")} ({weekday[datetime.datetime.today().weekday()+1]})']])
        write_matrix['cells'].append('H1:H1')
        write_matrix['values'].append([[f'{str(datetime.date.today() + datetime.timedelta(days=1)).replace("-","/")} ({weekday[datetime.datetime.today().weekday()+1]})']])

        #找縫隙，填資料
        for i in self.database:
            try: self.database[i]['Come_Person']
            except: break
            else:
                # sheet.cell(f'{car_row[CAR_index_num]}{lan[CAR_index_num]}').value = f"{i}車\n{database[i]['Come_ID']}"
                write_matrix['cells'].append(f'{car_row[CAR_index_num]}{lan[CAR_index_num]}:{car_row[CAR_index_num]}{lan[CAR_index_num]+3}')
                write_matrix['values'].append([[f"{i}車\n{self.database[i]['Come_ID']}"]])

                write_matrix['cells'].append(f'{name_row[CAR_index_num]}{lan[CAR_index_num]}:{name_row[CAR_index_num]}{lan[CAR_index_num]+3}')
                write_matrix['values'].append(self.database[i]['Come_Person'])
                
                CAR_index_num += 1
            
        # 沒事填個空
        for i in range(CAR_index_num,12):
            # sheet.cell(f'{car_row[CAR_index_num]}{lan[CAR_index_num]}').value = f""
            write_matrix['cells'].append(f'{car_row[CAR_index_num]}{lan[CAR_index_num]}:{car_row[CAR_index_num]}{lan[CAR_index_num]+3}')
            write_matrix['values'].append([[""]])

            write_matrix['cells'].append(f'{name_row[CAR_index_num]}{lan[CAR_index_num]}:{name_row[CAR_index_num]}{lan[CAR_index_num]+3}')
            write_matrix['values'].append([[""],[""],[""],[""]])

            CAR_index_num += 1

        sheet.update_values_batch(ranges=write_matrix['cells'], values=write_matrix['values'])

    def write_sheet2_data(self, thread1):
        sht1 = self.client.open_by_url(sheet_url)
        sheet1 = sht1.worksheet_by_title(worksheet2_name)
        write_matrix = {'cells':[], 'values':[]}

        weekday = ["一","二","三","四","五","六","日","一"]
        car_row = ['A','E','I','A','E','I','A','E','I','N','R','V']
        name_row = ['B','F','J','B','F','J','B','F','J','O','S','W']
        lan = [3,3,3,7,7,7,11,11,11,3,3,3]
        CAR_index_num = 0

        write_matrix['cells'].append('A1:L1')
        write_matrix['values'].append([[f'{str(datetime.date.today() + datetime.timedelta(days=1)).replace("-","/")} ({weekday[datetime.datetime.today().weekday()+1]})']])
        write_matrix['cells'].append('N1:Y1')
        write_matrix['values'].append([[f'{str(datetime.date.today() + datetime.timedelta(days=1)).replace("-","/")} ({weekday[datetime.datetime.today().weekday()+1]})']])

        for i in self.database:
            try: self.database[i]['Come_Person']
            except: break
            else:
                # sheet.cell(f'{car_row[CAR_index_num]}{lan[CAR_index_num]}').value = f"{i}車\n{database[i]['Come_ID']}"
                write_matrix['cells'].append(f'{car_row[CAR_index_num]}{lan[CAR_index_num]}:{car_row[CAR_index_num]}{lan[CAR_index_num]+2}')
                write_matrix['values'].append([[f"{i}車\n{self.database[i]['Come_ID']}"]])

                write_matrix['cells'].append(f'{name_row[CAR_index_num]}{lan[CAR_index_num]}:{name_row[CAR_index_num]}{lan[CAR_index_num]+3}')
                write_matrix['values'].append(self.database[i]['Come_Person'])
                
                CAR_index_num += 1

        # 沒事填個空
        for i in range(CAR_index_num,12):
            # sheet.cell(f'{car_row[CAR_index_num]}{lan[CAR_index_num]}').value = f""
            write_matrix['cells'].append(f'{car_row[CAR_index_num]}{lan[CAR_index_num]}:{car_row[CAR_index_num]}{lan[CAR_index_num]+2}')
            write_matrix['values'].append([[""]])

            write_matrix['cells'].append(f'{name_row[CAR_index_num]}{lan[CAR_index_num]}:{name_row[CAR_index_num]}{lan[CAR_index_num]+3}')
            write_matrix['values'].append([[""],[""],[""],[""]])

            CAR_index_num += 1

        sheet1.update_values_batch(ranges=write_matrix['cells'], values=write_matrix['values'])
        
        thread1.join()
        self.ui.Status_Text.setText(f"上傳完成，耗時: {str(time.time() - self.usetime)[0:5]} 秒")


if __name__ == '__main__':
    import sys
    app = QtWidgets.QApplication(sys.argv)
    window = MainWindow_controller()
    #.setFixedSize(432,550)
    window.show()
    app.exec_()