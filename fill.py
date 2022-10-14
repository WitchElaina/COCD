import pyautogui
import os
import time

select_item = ['A\n','B\n','C\n','D\n']


def getSource(inst_num):
    inst = []
    with open('.'+os.sep+'assembly_source'+os.sep+str(inst_num)+'.txt') as f:
        inst = f.readlines()
    return inst

def getAnsList(num, section):
    ans = []
    with open('.'+os.sep+'answer'+os.sep+str(num)+str(section)+'.txt') as f:
        inst = f.readlines()
    return inst


def autoFill(inst):
    for i in inst:
        pyautogui.typewrite(str(i))
        pyautogui.hotkey('tab')

        
def ans2Keyboard(ans):
    global select_item
    # get ans num
    ans_num = select_item.index(ans) + 1
    for i in range(ans_num):
        pyautogui.hotkey('tab')
    
    # select and submit
    pyautogui.hotkey('space')
    pyautogui.hotkey('enter')


def inputAns(ans):
    for i in ans:
        ans2Keyboard(i)
        
        
if __name__ == '__main__':
    print('选择实验(输入1或2)>', end='')
    num = input()
    
    print('实验'+str(num)+'将在5s后自动补全，请迅速点击第一行输入框，随后等待即可')
    time.sleep(5)
    autoFill(getSource(num))
    
    # print('完成仿真后打开冲关答题，输入任意字符并回车，然后切换至浏览器窗口，将自动答题')
    # input()
    # time.sleep(5)
    # inputAns(getAnsList(num, 1))
    
    # print('完成仿真后打开冲关答题，输入任意字符并回车，然后切换至浏览器窗口，将自动答题')
    # input()
    # time.sleep(5)
    # inputAns(getAnsList(num, 2))
    
    