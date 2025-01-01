classdef InformationTheoryWork < matlab.apps.AppBase
    
    % GUI控件
    properties (Access = private)
        UIFigure            matlab.ui.Figure
        titleLabel    matlab.ui.control.Label
        ModeLabel matlab.ui.control.Label
        ModeDropDown matlab.ui.control.DropDown
        TextArea            matlab.ui.control.TextArea
        EncodeButton        matlab.ui.control.Button
        gloablMode = 1
        EncryptButton    matlab.ui.control.Button
        KeyArea     matlab.ui.control.TextArea
        DecryptButton  matlab.ui.control.Button
        globalEncrypt
        CompressButton matlab.ui.control.Button
        Label_CompressTextLen matlab.ui.control.Label
        globalCompress
        DecompressButton  matlab.ui.control.Button
        SaveCodeButton   matlab.ui.control.Button
        ImportButton   matlab.ui.control.Button
        globalEncodedText
        EncodedTextArea     matlab.ui.control.TextArea
        TextLabel                   matlab.ui.control.Label
        CodeLabel                 matlab.ui.control.Label
        EfficiencyLabel           matlab.ui.control.Label
        HxLabel           matlab.ui.control.Label
        avgLenLabel           matlab.ui.control.Label
        %输入形式选择
        inputFormDropDown  matlab.ui.control.DropDown
        inputFormLabel     matlab.ui.control.Label
        globalInputFlag = 1  %app内的全局变量，判断选择的输入方式
        %编码方式选择
        codeFormDropDown matlab.ui.control.DropDown
        codeFormLabel    matlab.ui.control.Label
        globalCodeFlag = 1 %app内的全局变量，判断选择的编码方式
        %姓名学号
        Label_Name   matlab.ui.control.Label
        Label_ID  matlab.ui.control.Label
        Label_TextLen matlab.ui.control.Label
        Label_InputInfo matlab.ui.control.Label
        
    end
    
    % 回调函数
    methods (Access = private)
        
        % 模式选择回调函数
        function ModeDropDownValueChanged(app, event)
            value = app.ModeDropDown.Value;
            if value == "编码"
                app.inputFormLabel.Visible = 'on';
                
                app.gloablMode = 1;
                app.titleLabel.Text = '常用无失真信源编码方法(编码模式)';
                app.TextArea.Value = 'Enter some text in the input box.';
                app.TextLabel.Text = '请输入你要编码的文本或者信源符号概率 ：';
                app.CodeLabel.Text = '下面是编码区域';
                app.EncodeButton.Visible = 'on';
                app.inputFormLabel.Text = '输入形式 : ';
                app.codeFormLabel.Visible = 'on';
                app.codeFormDropDown.Visible = 'on';
                app.inputFormLabel.Visible = 'on';
                app.inputFormDropDown.Visible = 'on';
                
                app.EncryptButton.Visible = 'off';
                app.KeyArea.Visible = 'off';
                app.DecryptButton.Visible = 'off';
                
                app.CompressButton.Visible = 'off';
                app.DecompressButton.Visible = 'off';
                app.Label_CompressTextLen.Visible = 'off';
                
            elseif value == "加密"
                app.inputFormLabel.Visible = 'on';
                
                app.gloablMode = 2;
                app.titleLabel.Text = '        加密模式';
                app.TextArea.Value = 'Enter the text that needs to be encrypted.';
                app.TextLabel.Text = '           请输入加密的文本 ：';
                app.CodeLabel.Text = ' 下面是加密后文本:';
                app.EncodeButton.Visible = 'off';
                app.codeFormLabel.Visible = 'off';
                app.codeFormDropDown.Visible = 'off';
                app.inputFormDropDown.Visible = 'off';
                
                app.EncryptButton.Visible = 'on';
                app.inputFormLabel.Text = '输入密钥 : ';
                app.KeyArea.Visible = 'on';
                app.DecryptButton.Visible = 'on';
                
                app.CompressButton.Visible = 'off';
                app.DecompressButton.Visible = 'off';
                
                app.HxLabel.Visible = 'off';
                app.avgLenLabel.Visible = 'off';
                app.EfficiencyLabel.Visible = 'off';
                app.Label_CompressTextLen.Visible = 'off';
                
            elseif value == "压缩"
                app.gloablMode = 3;
                app.titleLabel.Text = '        压缩模式';
                app.TextArea.Value = 'Enter the text to be compressed.';
                app.TextLabel.Text = '           请输入压缩的文本 ：';
                app.CodeLabel.Text = '下面是压缩后文本 ： ';
                app.EncodeButton.Visible = 'off';
                app.codeFormLabel.Visible = 'off';
                app.codeFormDropDown.Visible = 'off';
                app.inputFormDropDown.Visible = 'off';
                
                app.EncryptButton.Visible = 'off';
                app.KeyArea.Visible = 'off';
                app.DecryptButton.Visible = 'off';
                
                app.CompressButton.Visible = 'on';
                app.DecompressButton.Visible = 'on';
                app.inputFormLabel.Visible = 'off';
                app.HxLabel.Visible = 'off';
                app.avgLenLabel.Visible = 'off';
                app.EfficiencyLabel.Visible = 'off';
                
            end
        end
        
        % 编码回调函数
        function EncodeButtonPushed(app, event)
            % 获取文本区域中的文本
            inputText = app.TextArea.Value;
            % 使用reshape将其转换为一行字符数组
            reshapedData =  cell2mat(inputText.');
            encodedText  = '';
            efficiency  =0;
            
            if app.globalInputFlag == 1
                %文本输入，所以先处理文本
                textData = reshapedData;
                %文本长度
                textLen = length(textData);
                textLenText = ['文本长度为 ', num2str(textLen)];
                app.Label_TextLen.Text = textLenText;
                % 去重
                uniqueChr = myUnique(app, textData);
                % 每个字符的个数
                uniqueChrNum = zeros(1, 300);
                % 每个字符出现的频率（概率）
                uniqueChrPr = zeros(1, length(uniqueChr));
                %不同字符的个数
                numOfChr = length(uniqueChr);
                %计算每个字符出现的次数
                for i = 1:length(textData)
                    uniqueChrNum( double( textData(i) ) ) = uniqueChrNum( double(textData(i) ) ) + 1;%统计字符的数目
                end
                %计算每个字符出现的概率
                for i = 1:numOfChr
                    uniqueChrPr(i) = (uniqueChrNum( double(uniqueChr(i)) ) / length(textData) ); % 不同字符出现的概率
                end
                
                if app.globalCodeFlag == 1
                    %进行香农编码
                    [Hx, avgLen, efficiency, shannonCode] = shannon(app, uniqueChrPr);
                    resultCode = shannonCode;
                    app.CodeLabel.Text = '香农(Shannon)编码如下 ： ';
                elseif app.globalCodeFlag == 2
                    %进行费诺编码
                    [Hx, avgLen, efficiency, fanoCode] = fano(app, uniqueChrPr);
                    resultCode = fanoCode;
                    app.CodeLabel.Text = '费诺(Fano)编码如下 ： ';
                elseif app.globalCodeFlag == 3
                    %进行哈夫曼编码
                    [Hx, avgLen, efficiency, huffmanCode] = huffman(app, uniqueChrPr);
                    resultCode = huffmanCode;
                    app.CodeLabel.Text = '哈夫曼(Huffman)编码如下 ： ';
                end
                
                alphaOrderCode = uniqueChr';
                for i = 1 : numOfChr
                    alphaOrderCode(i, 3: length( resultCode(i,:) ) +2 ) = resultCode(i,:);
                end
                alphaOrderCode = sortrows([alphaOrderCode(:, 1), alphaOrderCode(:, 3:end)]);
                % 编辑输出编码格式
                for i = 1:length(resultCode)
                    entry = alphaOrderCode(i) ;
                    TempCode =  alphaOrderCode(i, 2:end );
                    RealCode = '';
                    % 手动移除末尾的空格并从 TempCode 中提取数字部分添加到 RealCode
                    i = 1;
                    while ( i <=length(TempCode) )
                        if (TempCode(i) >= '0') && (TempCode(i) <= '9' )
                            RealCode = [TempCode(i), RealCode];
                        end
                        i = i + 1;
                    end
                    % 注意这里，直接使用 entry，因为 sortedCode 是字符串或字符数组
                    encodedText = encodedText + ...
                        "   '" + entry + "'   :   " + RealCode + "   " + newline;
                end
                
            elseif app.globalInputFlag==2
                %将概率用 ',' 分隔开
                str_cell = strsplit(reshapedData, ',');
                prData = str2double(str_cell);
                sumPr = 0;
                %检查输入是否有负值和概率和是否等于1
                for i = 1 : length(prData)
                    if prData(i) < 0
                        warndlg('输入的概率有负值！请检查输入') ;
                        return;
                    end
                    sumPr = sumPr + prData(i);
                end
                tolerance = 1e-6;  % 设置一个允许的误差范围，根据实际情况调整
                if abs(sumPr - 1) > tolerance
                    warndlg('输入的概率和不等于1！请检查输入');
                    return;
                end
                
                numOfPr = length(prData);
                textLenText = ['输入概率个数为 ', num2str(numOfPr)];
                app.Label_TextLen.Text = textLenText;
                
                %提前对输入概率排序，短码在前面，长码在后面
                [prData, sortedprDataIndex] = sort(prData, 'descend');
                str_cell = str_cell(sortedprDataIndex);
                
                if app.globalCodeFlag == 1
                    %进行香农编码
                    [Hx, avgLen, efficiency, shannonCode] = shannon(app, prData);
                    resultCode = shannonCode;
                    app.CodeLabel.Text = '香农(Shannon)编码如下 ： ';
                elseif app.globalCodeFlag == 2
                    %进行费诺编码
                    [Hx, avgLen, efficiency, fanoCode] = fano(app, prData);
                    resultCode = fanoCode;
                    app.CodeLabel.Text = '费诺(Fano)编码如下 ： ';
                elseif app.globalCodeFlag == 3
                    %进行哈夫曼编码
                    [Hx, avgLen, efficiency, huffmanCode] = huffman(app, prData);
                    resultCode = huffmanCode;
                    app.CodeLabel.Text = '哈夫曼(Huffman)编码如下 ： ';
                end
                % 编辑输出编码格式
                encodedText  = '';
                for i = 1:length(resultCode)
                    entry = str_cell(i) ;
                    TempCode =  resultCode(i,:);
                    RealCode = '';
                    % 手动移除末尾的空格并从 TempCode 中提取数字部分添加到 RealCode
                    i = 1;
                    while ( i <=length(TempCode) )
                        if (TempCode(i) >= '0') && (TempCode(i) <= '9' )
                            RealCode = [TempCode(i), RealCode];
                        end
                        i = i + 1;
                    end
                    % 注意这里，直接使用 entry，因为 sortedCode 是字符串或字符数组
                    encodedText = encodedText + ...
                        "   '" + entry + "'   :   " + RealCode + "   " + newline;
                end
                
            end
            
            app.EncodedTextArea.Value = encodedText;
            app.globalEncodedText = encodedText;
            
            efficiency = efficiency*100;
            efficiencyText = ['编码效率为： ', num2str(efficiency), '% '];
            avgLenText = ['平均码长为： ', num2str(avgLen)];
            HxText = ['熵(平均自信息量) 为 ：  ', num2str(Hx)];
            
            app.EfficiencyLabel.Text = efficiencyText;
            app.avgLenLabel.Text = avgLenText;
            app.HxLabel.Text = HxText;
            
            app.EfficiencyLabel.Visible = 'on';
            app.avgLenLabel.Visible = 'on';
            app.HxLabel.Visible = 'on';
            app.Label_TextLen.Visible = 'on';
            app.Label_InputInfo.Visible = 'on';
            app.SaveCodeButton.Visible = 'on';
        end
        
        % 加密回调函数
        function EncryptButtonPushed(app, event)
            % 获取文本区域中的文本
            inputText = app.TextArea.Value;
            % 使用reshape将其转换为一行字符数组
            reshapedText =  cell2mat(inputText.');
            
            % 获取文本区域中的文本
            inputKey = app.KeyArea.Value;
            % 使用reshape将其转换为一行字符数组
            reshapedKey =  cell2mat(inputKey.');
            
            %文本输入，所以先处理文本
            textData = reshapedText;
            %文本长度
            textLen = length(textData);
            textLenText = ['文本长度为 ', num2str(textLen)];
            app.Label_TextLen.Text = textLenText;
            
            encryptedText = Encrypt(app, reshapedText, reshapedKey);
            
            app.EncodedTextArea.Value = encryptedText;
            app.globalEncrypt = encryptedText;
            app.Label_TextLen.Visible = 'on';
            app.Label_InputInfo.Visible = 'on';
            app.SaveCodeButton.Visible = 'on';
            app.CodeLabel.Text = ' 下面是加密后文本:';
        end
        
        % 解密回调函数
        function DecryptButtonPushed(app, event)
            % 获取文本区域中的文本
            inputText = app.TextArea.Value;
            % 使用reshape将其转换为一行字符数组
            reshapedText =  cell2mat(inputText.');
            
            % 获取文本区域中的文本
            inputKey = app.KeyArea.Value;
            % 使用reshape将其转换为一行字符数组
            reshapedKey =  cell2mat(inputKey.');
            
            %文本输入，所以先处理文本
            textData = reshapedText;
            %文本长度
            textLen = length(textData);
            textLenText = ['文本长度为 ', num2str(textLen)];
            app.Label_TextLen.Text = textLenText;
            
            decyptedText = Decrypt(app, reshapedText, reshapedKey);
            
            app.EncodedTextArea.Value = decyptedText;
            app.Label_TextLen.Visible = 'on';
            app.Label_InputInfo.Visible = 'on';
            app.SaveCodeButton.Visible = 'on';
            app.CodeLabel.Text = ' 下面是解密后文本:';
        end
        
        % 压缩回调函数
        function CompressButtonPushed(app, event)
            % 获取文本区域中的文本
            inputText = app.TextArea.Value;
            % 使用reshape将其转换为一行字符数组
            reshapedData =  cell2mat(inputText.');
            %文本输入，所以先处理文本
            textData = reshapedData;
            %文本长度
            textLen = length(textData);
            textLenText = ['文本长度为 ', num2str(textLen)];
            app.Label_TextLen.Text = textLenText;
            compressedText = compressTextLZW(app, textData);
            
            compressTextLen = length(compressedText);
            textLenText = ['压缩后文本长度为 ', num2str(compressTextLen)];
            app.Label_CompressTextLen.Text = textLenText;
            
            app.globalCompress = compressedText;
            
            app.EncodedTextArea.Value = char(compressedText);
            app.Label_TextLen.Visible = 'on';
            app.Label_InputInfo.Visible = 'on';
            app.SaveCodeButton.Visible = 'on';
            app.Label_CompressTextLen.Visible = 'on';
            app.CodeLabel.Text = ' 下面是压缩后文本:';
        end
        
        % 解压缩回调函数
        function DecompressButtonPushed(app, event)
            % 获取文本区域中的文本
            inputText = app.TextArea.Value;
            % 使用reshape将其转换为一行字符数组
            reshapedData =  cell2mat(inputText.');
            %文本输入，所以先处理文本
            textData = reshapedData;
            %文本长度
            textLen = length(textData);
            textLenText = ['文本长度为 ', num2str(textLen)];
            app.Label_TextLen.Text = textLenText;
            decompressedText = decompressTextLZW(app, textData);
            
            decompressedTextLen = length(decompressedText);
            textLenText = ['解压后文本长度为 ', num2str(decompressedTextLen)];
            app.Label_CompressTextLen.Text = textLenText;
            
            app.EncodedTextArea.Value = char(decompressedText);
            app.Label_TextLen.Visible = 'on';
            app.Label_InputInfo.Visible = 'on';
            app.SaveCodeButton.Visible = 'on';
            app.Label_CompressTextLen.Visible = 'on';
            app.CodeLabel.Text = ' 下面是解压缩后文本:';
        end
        
        % 输入形式选择回调函数
        function inputDropDownValueChanged(app, event)
            value = app.inputFormDropDown.Value;
            if value == "文本"
                app.globalInputFlag = 1; %改变标志，在huffman编码时按选择进行编码
                app.TextArea.Value = 'Enter some text in the input box.';
                app.ImportButton.Text = '导入';
            elseif value == "信源符号概率"
                app.globalInputFlag = 2; %改变标志，在huffman编码时按选择进行编码
                app.TextArea.Value = '0.1,0.2,0.3,0.3,0.1';
                app.ImportButton.Text = '导入';
            end
        end
        
        % 编码方式回调函数
        function codeDropDownValueChanged(app, event)
            value = app.codeFormDropDown.Value;
            if value == "香农(Shannon)编码"
                app.globalCodeFlag = 1; %改变标志，选择香农编码
            elseif value == "费诺(Fano)编码"
                app.globalCodeFlag = 2; %改变标志，选择费诺编码
            elseif value == "哈夫曼(Huffman)编码"
                app.globalCodeFlag = 3; %改变标志，选择哈夫曼编码
            end
        end
        
        %导出
        function SaveCode_Callback(app, event)
            % 保存结果回调函数
            % 参数：
            % - app: 应用程序对象
            % - event: 事件对象
            % 弹出文件保存对话框，获取保存路径和文件名
            [file, path] = uiputfile('*.txt', '保存编码格式为');
            
            % 检查是否选择了合法路径和文件
            if path == 0
                warndlg('未选择合法路径或文件！');
                return;
            end
            
            % 拼接保存路径和文件名
            savePath = [path file];
            
            try
                % 打开文件进行写入
                fid = fopen(savePath, 'w');
                
                % 检查文件是否成功打开
                if fid == -1
                    warndlg('无法打开文件进行写入。');
                    return;
                end
                
                % 根据全局模式将文本数据写入文件
                if app.gloablMode == 1
                    fprintf(fid ,'%s', app.globalEncodedText );
                elseif app.gloablMode == 2
                    fprintf(fid ,'%s', app.globalEncrypt );
                elseif app.gloablMode == 3
                    fprintf(fid ,'%s', app.globalCompress );
                end
                
                % 关闭文件
                fclose(fid);
                
                disp(['文件 ', savePath, ' 写入成功!']);
            catch
                % 发生错误时关闭文件并弹出警告对话框
                fclose(fid);
                warndlg('写入文件时发生错误。');
            end
        end
        
        %导入
        function Import_Callback(app, event)
            % 导入回调函数
            % 参数：
            % - app: 应用程序对象
            % - event: 事件对象
            % 打开文件选择对话框，获取选择的文件路径和文件名
            [file, path] = uigetfile({'*.txt'}, '打开文件');
            importFile = [path file];
            
            % 如果用户取消选择文件，弹出警告对话框
            if (file == 0)
                warndlg('您没有选择文件。') ;
                return;
            end
            
            % 获取文件扩展名
            [fpath, fname, fext] = fileparts(file);
            
            % 检查文件扩展名是否合法
            % 如果文件扩展名不合法，弹出错误对话框
            if (fext ~= '.txt')
                errordlg('文件扩展名不正确，请选用txt文件！');
                return;
            end
            
            try
                % 读取文件内容
                fileContent = fileread(importFile);
                
                % 将文件内容设置到 TextArea 的 Value 属性中
                app.TextArea.Value = fileContent;
                
                disp('文件内容成功导入到 TextArea 中。');
            catch
                % 如果发生错误，弹出错误对话框
                errordlg('读取文件内容时发生错误。');
            end
        end
        
    end
    
    %算法实现的相关函数
    methods (Access = private)
        
        % 计算输入字符串中的唯一字符
        function uniqueChars = myUnique(~, inputString)
            uniqueChars = '';  % 初始化存储不重复字符的字符串
            
            % 遍历输入字符串中的每个字符
            for i = 1:length(inputString)
                % 如果当前字符不在存储不重复字符的字符串中，将其添加进去
                if ~contains(uniqueChars, inputString(i))
                    uniqueChars = [uniqueChars, inputString(i)];
                end
            end
        end
        
        % 哈夫曼编码
        function [code, code_len] = huffmanCoding(~, matrix, character)
            % 输入参数：
            %   ~: 未使用的参数占位符
            %   matrix: 哈夫曼树节点矩阵，每行包含字符的根节点和左右孩子
            %   character: 待编码的字符
            
            [numofRow,  ~] = size(matrix); % 获取矩阵的行数
            
            % 初始化编码变量
            temp_code = '';
            assignin('base', 'matrix', matrix); % 在工作区中分配 matrix 变量
            
            % 遍历哈夫曼树的每一行
            while(1)
                % 查找字符在 matrix 中的位置
                for row = 1 : numofRow
                    if(double(character) == matrix(row, 2))
                        tempRow  = row; % 找到字符对应的行
                        tempCol = 2;
                        break;
                    end
                    if(double(character) == matrix(row, 3))
                        tempRow  = row; % 找到字符对应的行
                        tempCol = 3;
                        break;
                    end
                end
                % 更新字符为对应的根节点
                character = matrix(tempRow, 1); % 将字符更新为其对应的根节点
                
                % 根据左右孩子的位置添加 '0' 或 '1' 到编码中
                % 左0右1
                if tempCol == 2
                    temp_code = ['0', temp_code]; % 如果是左孩子，添加 '0'
                else
                    temp_code = ['1', temp_code]; % 如果是右孩子，添加 '1'
                end
                
                % 如果已经到达根节点，结束循环
                if row == numofRow
                    break
                end
            end
            
            % 返回编码结果和编码长度
            code = temp_code;
            code_len = length(code);
        end
        
        % 输入的内容为概率分布构建哈夫曼树
        function [Hx, avgLen, efficiency, huffmanCode] = huffman(app, pr)
            % 输入参数：
            %   app: 未使用的输入参数
            %   pr: 包含不同字符概率分布的向量
            
            % 不同字符的个数
            numOfPr = length(pr);
            
            % 哈夫曼编码的总长度
            avgLen = 0;
            Hx = 0;
            
            % 对每一个概率添加一个唯一的标识 symbol，方便后面建树
            % 为了不影响字符，所以加一个较大的数
            for i = 1 : numOfPr
                symbol(i) = i+10457; % symbol（1~numofPr) 对应概率升序
            end
            
            tempSymbol = symbol;
            
            % 创建哈夫曼树
            [prSorted, prSortedIndex] = sort(pr);
            matrix = zeros(numOfPr - 1, 3); % 哈夫曼树数组
            
            % 将概率的唯一标识按概率从小到大排列
            tempSymbol = tempSymbol(prSortedIndex);
            for mergeIndex = 1 : numOfPr-1
                matrix(mergeIndex, 2) = tempSymbol(1); % 在 matrix 2 中记录左孩子
                matrix(mergeIndex, 3) = tempSymbol(2); % 在 matrix 3 中记录右孩子
                
                % 将原来概率较大的符号变为合并后的新符号，赋值为 mergeI + 256
                % 加 128 是为了不影响 ASCII 码范围内的 char 变量
                tempSymbol(2) = double(mergeIndex + 128);
                % 概率取原来最小的两个概率之和
                prSorted(2) = prSorted(1) + prSorted(2); % 更新根节点数值
                % 删除较小概率的结点，即概率赋值为 1，保证其排到最后面
                prSorted(1) = 1; % 补充数值 1，目的是为了以后排序该位置总排在最后，不被处理
                
                % 合并的两个结点的根节点，赋值为合并后的新符号(上面新添加的）
                matrix(mergeIndex, 1) = tempSymbol(2);
                
                % 对新的概率组合进行排序
                [prResorted, prResortedIndex] = sort(prSorted);
                tempSymbol = tempSymbol(prResortedIndex); % 剩余字符排好序，概率小的在前面
                prSorted = prResorted; % 将概率排好序
            end
            
            for i = 1 : numOfPr
                [tmp_code, tcode_len] = huffmanCoding(app, matrix, symbol(i)); % 对每个字符进行编码
                huffmanCode(i, 1 : tcode_len) = tmp_code;
                
                % 平均码长
                avgLen = avgLen + pr(i) * tcode_len;
                % 熵
                Hx = Hx + pr(i) * (-log2(pr(i)));
            end
            
            % 编码效率
            efficiency = Hx / (avgLen * log2(2));
        end
        
        % 香农编码
        function [Hx, avgLen, efficiency, shannonCode] = shannon(~, pr)
            % 输入参数：
            %   ~: 未使用的参数占位符
            %   pr: 一个包含了各个信源符号概率的数组
            % 输出参数:
            %   Hx: 信源熵
            %   avgLen: 平均码字长度
            %   efficiency: 编码效率
            %   shannonCode: 费诺编码结果的二维数组
            % 计算信源符号数量
            numOfPr = length(pr);
            % 计算每个符号的码长
            codeLen = ceil(-log2(pr));
            % 计算累加概率（P）和对应的码字
            [sortedPr, sortedPrIndex] = sort(pr, 'descend');
            cumulativePr = zeros(1, numOfPr);
            
            % 依次处理每个概率的编码
            for i = 1:numOfPr
                % 初始化当前符号的码字
                currentCode = '';
                
                % 处理第一个符号的情况
                if i == 1
                    cumulativePr(1) = 0;
                else
                    % 计算累加概率
                    cumulativePr(i) = sum(sortedPr(1:i-1));
                end
                
                % 生成香农码（累加概率的二进制表示）
                prCount = cumulativePr(i) * 2;
                
                for j = 1:codeLen(sortedPrIndex(i))
                    % 根据累加概率生成二进制码字
                    if prCount >= 1
                        currentCode = strcat(currentCode, '1');
                        prCount = prCount - 1;
                    else
                        currentCode = strcat(currentCode, '0');
                    end
                    
                    prCount = prCount * 2;
                end
                % 将生成的香农码赋值给对应的符号
                shannonCode(sortedPrIndex(i), 1:codeLen(sortedPrIndex(i))) = currentCode;
            end
            % 计算信源信息熵
            Hx = sum(-pr .* log2(pr));
            % 计算平均码长
            avgLen = sum(codeLen .* pr);
            % 计算编码效率
            efficiency = Hx / (avgLen * log2(2));
        end
        
        % 费诺编码
        function [Hx, avgLen, efficiency, fanoCode] = fano(app, pr)
            % Fano编码函数，用于对给定的信源概率进行费诺编码
            % 输入参数:
            %   app: 用于指定对象实例的参数（如果有）
            %   pr: 一个包含了各个信源符号概率的数组
            % 输出参数:
            %   Hx: 信源熵
            %   avgLen: 平均码字长度
            %   efficiency: 编码效率
            %   fanoCode: 费诺编码结果的二维数组
            
            % 1) 对概率进行排序
            numOfPr = length(pr); % 获取信源符号数量
            
            % 2) 将信源符号分组并得到对应的码字
            for i = 1:numOfPr
                currentIndex = i; % 当前符号的索引
                j = 1; % 初始化码字数组的索引
                currentPr = pr; % 复制一份概率数组，用于迭代
                
                while true
                    [nextPr, codeNum, nextIndex] = compare(app, currentPr, currentIndex);
                    currentIndex = nextIndex;
                    currentPr = nextPr; %每次迭代，currentPr等于上次的一半
                    
                    fanoCode(i, j) = codeNum; % 将得到的码字存入数组
                    j = j + 1;
                    
                    if length(currentPr) == 1 % 如果分组完成，跳出循环
                        break;
                    end
                end
                
                fanoCode(i, :) = fliplr(fanoCode(i, :));
                len(i) = length( find(abs(fanoCode(i, :)) ~= 0) ); % 计算各码字的长度
            end
            avgLen = sum(pr .* len); % 计算平均码字长度
            Hx = sum(pr .* (-log2(pr))); % 计算信源熵
            efficiency = Hx / ( avgLen*log2(2) ); % 计算编码效率
        end
        
        % 费诺编码的比较函数
        function [nextPr, codeNum, nextIdx] = compare(app, currentPr, currentIndex)
            % 用于在费诺编码中比较概率并进行分组的函数
            % 输入参数:
            %   app: 用于指定对象实例的参数（如果有）
            %   currentPr: 当前待比较的概率数组
            %   currentIndex: 当前信源符号的索引
            % 输出参数:
            %   nextPr: 下一个待比较的概率数组
            %   codeNum: 当前信源符号的码字
            %   nextIdx: 下一个信源符号的索引
            
            n = length(currentPr);  % 获取概率向量的长度
            
            % 步骤1：计算累积概率
            cumulativePr = cumsum(currentPr);  % 对概率向量进行累积求和
            
            % 步骤2：找到最接近的分割点
            totalPr = cumulativePr(n);  % 获取总概率
            temp = abs(totalPr - 2 * cumulativePr);  % 计算与2倍累积概率的差的绝对值
            [~, splitIdx] = min(temp);  % 找到最小差值对应的索引
            
            % 步骤3：根据分割点赋予ASCII值
            if currentIndex <= splitIdx
                nextIdx = currentIndex;  % 下一个索引为当前索引
                codeNum = '0';
                nextPr = currentPr(1:splitIdx);  % 下一个概率向量为前半部分
            else
                nextIdx = currentIndex - splitIdx;  % 下一个索引为当前索引减去分割点
                codeNum = '1';
                nextPr = currentPr(splitIdx + 1:end);  % 下一个概率向量为后半部分
            end
        end
        
        % 加密函数
        function encryptedText = Encrypt(app, text, key)
            % Encrypt函数用于对文本进行加密。
            % 参数:
            %   - app: 应用程序对象，可用于与应用程序其他部分交互（未在此代码中使用）。
            %   - text: 待加密的文本。
            %   - key: 加密密钥。
            % 输出：
            %   - encryptedText: 加密后的文本。
            
            % 将文本和密钥转换为ASCII值
            textASCII = double(text);  % 将文本转换为ASCII值
            keyASCII = double(key);     % 将密钥转换为ASCII值
            
            % 密钥调度：使用简单的密钥混合算法
            for i = 1:length(keyASCII)  % 遍历密钥的每个字符
                keyASCII(i) = bitxor(keyASCII(i), bitshift(i, mod(i, 7) + 1));  % 对每个字符进行位异或和位移运算
            end
            
            % 重复密钥以匹配文本长度
            repeatedKey = repmat(keyASCII, 1, ceil(length(textASCII) / length(keyASCII)));  % 将密钥重复以匹配文本长度
            repeatedKey = repeatedKey(1:length(textASCII));  % 截取适当长度的重复密钥
            
            % 替换：使用XOR操作对文本和密钥进行混合
            encryptedText = bitxor(textASCII, repeatedKey);  % 使用位异或操作对文本和密钥进行混合
            
            % 置换：颠倒字符顺序
            encryptedText = encryptedText(end:-1:1);  % 颠倒混合后的字符顺序
            
            % 将加密后的值转换回字符串，即数字串
            encryptedText = num2str(encryptedText);  % 将加密后的ASCII值转换为字符串
        end
        
        % 解密函数
        function decryptedText = Decrypt(app, encryptedText, key)
            % Decrypt函数用于对加密文本进行解密。
            % 参数:
            %   - app: 应用程序对象，可用于与应用程序其他部分交互（未在此代码中使用）。
            %   - encryptedText: 加密的文本。
            %   - key: 解密密钥。
            % 输出：
            %   - decryptedText: 解密后的文本。
            
            % 将加密文本和密钥转换为ASCII值
            encryptedText = str2num(encryptedText);
            
            keyASCII = double(key);
            
            % 密钥调度：使用相同的密钥混合算法
            for i = 1:length(keyASCII)
                keyASCII(i) = bitxor(keyASCII(i), bitshift(i, mod(i, 7) + 1));
            end
            
            % 重复密钥以匹配加密文本长度
            repeatedKey = repmat(keyASCII, 1, ceil(length(encryptedText) / length(keyASCII)));
            repeatedKey = repeatedKey(1:length(encryptedText));
            
            % 置换：颠倒字符顺序
            encryptedText = encryptedText(end:-1:1);
            
            % 替换：使用XOR操作对加密文本和密钥进行混合
            decryptedText = bitxor(encryptedText, repeatedKey);
            
            % 将解密后的值转换回字符
            decryptedText = char(decryptedText);
        end
        
        % 压缩函数
        function compressedText = compressTextLZW(app, text)
            % 使用 Lempel-Ziv-Welch（LZW）算法对输入文本进行压缩。
            % 参数：
            %   - app: 应用程序对象，可用于与应用程序其他部分交互（未在此代码中使用）。
            %   - text: 要压缩的文本。
            % 输出：
            %   - compressedText: 压缩后的文本。
            
            dictionary = containers.Map('KeyType', 'char', 'ValueType', 'int32'); % 创建一个键为字符类型，值为 int32 类型的容器对象作为字典
            dictSize = 256; % 初始化字典大小
            
            % 初始化字典
            for i = 0:255
                dictionary(char(i)) = i; % 将 ASCII 码值作为键，对应的字符作为值添加到字典中
            end
            
            currentCode = ''; % 初始化当前编码为空字符串
            compressedText = []; % 初始化压缩后的文本为空数组
            
            % 开始压缩
            for i = 1:length(text)
                % 将当前字符添加到当前编码中
                currentCode = [currentCode, text(i)]; % 将当前字符追加到当前编码后面
                if ~isKey(dictionary, currentCode)
                    % 如果字典中不存在当前编码，则：
                    % 将当前编码添加到字典中
                    dictionary(currentCode) = dictSize; % 将当前编码添加到字典中，并分配一个新的编码值
                    dictSize = dictSize + 1; % 字典大小加一
                    % 输出前缀编码
                    compressedText = [compressedText, dictionary(currentCode(1:end-1))]; % 将当前编码的前缀编码添加到压缩文本中
                    % 重置当前编码为当前字符
                    currentCode = text(i); % 重置当前编码为当前字符
                end
            end
            
            % 输出最后一个编码
            compressedText = [compressedText, dictionary(currentCode)]; % 将最后一个编码添加到压缩文本中
        end
        
        % 解压函数
        function decompressedText = decompressTextLZW(app, compressedText)
            % 使用 Lempel-Ziv-Welch（LZW）算法对输入文本进行解压缩。
            % 参数：
            %   - app: 应用程序对象，可用于与应用程序其他部分交互（未在此代码中使用）。
            %   - compressedText: 压缩后的文本。
            % 输出：
            %   - decompressedText: 解压缩后的文本。
            
            compressedText = double(compressedText);
            
            dictionary = containers.Map('KeyType', 'int32', 'ValueType', 'char'); % 创建一个键为 int32 类型，值为字符类型的容器对象作为字典
            dictSize = 256; % 初始化字典大小
            
            % 初始化字典
            for i = 0:255
                dictionary(i) = char(i); % 将 ASCII 码值作为键，对应的字符作为值添加到字典中
            end
            
            currentCode = compressedText(1); % 初始化当前编码为压缩文本的第一个编码
            decompressedText = dictionary(currentCode); % 初始化解压缩文本为当前编码对应的字符
            
            % 开始解压缩
            for i = 2:length(compressedText)
                if isKey(dictionary, compressedText(i))
                    entry = dictionary(compressedText(i)); % 如果字典中存在当前编码，则将其对应的字符赋值给 entry
                elseif compressedText(i) == dictSize
                    entry = [dictionary(currentCode), dictionary(currentCode(1))]; % 如果当前编码是字典中最后一个编码，则将前一个编码和前一个编码的第一个字符拼接作为 entry
                else
                    warndlg('无效的解压文本格式！'); % 提示无效的解压文本格式
                end
                
                % 添加到字典中
                dictionary(dictSize) = [dictionary(currentCode), entry(1)]; % 将当前编码和 entry 的第一个字符拼接作为新的编码，添加到字典中
                dictSize = dictSize + 1; % 字典大小加一
                
                % 添加到解压缩文本中
                decompressedText = [decompressedText, entry]; % 将 entry 添加到解压缩文本中
                
                % 更新当前编码
                currentCode = compressedText(i); % 更新当前编码为压缩文本的下一个编码
            end
        end
        
    end
    
    % App初始化
    methods (Access = private)
        
        % Create UIFigure and components
        function createComponents(app)
            % 创建主窗口
            app.UIFigure = uifigure('Name', '信息论大作业', 'Position', [190, 80, 1300, 800]);
            
            % 创建标签
            app.titleLabel = uilabel(app.UIFigure);
            app.titleLabel.Text = '常用无失真信源编码方法(编码模式)';
            app.titleLabel.FontWeight = 'bold';  % 加粗
            app.titleLabel.FontName = '宋体';  % 设置字体为 Consolas
            app.titleLabel.Position = [500, 700, 540, 80];
            app.titleLabel.FontSize = 33;
            app.titleLabel.FontColor = [0, 0, 0]; % RGB颜色值，可以根据需要调整
            
            % 创建标签
            app.TextLabel = uilabel(app.UIFigure);
            app.TextLabel.Text = '请输入你要编码的文本或者信源符号概率 ：';
            app.TextLabel.Position = [80, 640, 480, 80];
            app.TextLabel.FontSize = 24;
            app.TextLabel.FontColor = [0.1, 0.5, 0.8]; % RGB颜色值，可以根据需要调整
            
            % 在uipanel中创建uitextarea
            app.TextArea = uitextarea(app.UIFigure);
            app.TextArea.Position = [50, 30, 480, 500];
            app.TextArea.Value = 'Enter some text in the input box.';
            app.TextArea.FontName = 'Consolas';  % 设置字体为 Consolas
            app.TextArea.FontSize = 13;  % 设置字体大小
            app.TextArea.FontWeight = 'bold';  % 加粗
            
            % 创建编码按钮
            app.EncodeButton = uibutton(app.UIFigure, 'push');
            app.EncodeButton.Position = [600, 300, 100, 50];
            app.EncodeButton.Text = '编码';
            app.EncodeButton.ButtonPushedFcn = createCallbackFcn(app, @EncodeButtonPushed, true);
            % 设置字体、大小和颜色
            app.EncodeButton.FontSize = 30;  % 设置字体大小
            app.EncodeButton.FontColor = [1, 0, 0];  % 设置字体颜色为红色
            app.EncodeButton.Visible = 'on';
            
            % 创建加密按钮
            app.EncryptButton = uibutton(app.UIFigure, 'push');
            app.EncryptButton.Position = [600, 300, 100, 50];
            app.EncryptButton.Text = '加密';
            app.EncryptButton.ButtonPushedFcn = createCallbackFcn(app, @EncryptButtonPushed, true);
            % 设置字体、大小和颜色
            app.EncryptButton.FontSize = 30;  % 设置字体大小
            app.EncryptButton.FontColor = [1, 0, 0];  % 设置字体颜色为红色
            app.EncryptButton.Visible = 'off';
            
            % 创建编码按钮
            app.DecryptButton = uibutton(app.UIFigure, 'push');
            app.DecryptButton.Position = [600, 200, 100, 50];
            app.DecryptButton.Text = '解密';
            app.DecryptButton.ButtonPushedFcn = createCallbackFcn(app, @DecryptButtonPushed, true);
            % 设置字体、大小和颜色
            app.DecryptButton.FontSize = 30;  % 设置字体大小
            app.DecryptButton.FontColor = [1, 0, 0];  % 设置字体颜色为红色
            app.DecryptButton.Visible = 'off';
            
            % 在uipanel中创建uitextarea
            app.KeyArea = uitextarea(app.UIFigure);
            app.KeyArea.Position = [155 570 300 40];
            app.KeyArea.Value = 'QWERTYUIOPASDFGHJKLZXCVBNM';
            app.KeyArea.FontName = 'Consolas';  % 设置字体为 Consolas
            app.KeyArea.FontSize = 13;  % 设置字体大小
            app.KeyArea.FontWeight = 'bold';  % 加粗
            app.KeyArea.Visible = 'off';
            
            % 创建压缩按钮
            app.CompressButton = uibutton(app.UIFigure, 'push');
            app.CompressButton.Position = [600, 300, 100, 50];
            app.CompressButton.Text = '压缩';
            app.CompressButton.ButtonPushedFcn = createCallbackFcn(app, @CompressButtonPushed, true);
            % 设置字体、大小和颜色
            app.CompressButton.FontSize = 30;  % 设置字体大小
            app.CompressButton.FontColor = [1, 0, 0];  % 设置字体颜色为红色
            app.CompressButton.Visible = 'off';
            
            app.DecompressButton = uibutton(app.UIFigure, 'push');
            app.DecompressButton.Position = [600, 200, 100, 50];
            app.DecompressButton.Text = '解压';
            app.DecompressButton.ButtonPushedFcn = createCallbackFcn(app, @DecompressButtonPushed, true);
            app.DecompressButton.FontSize = 30;  % 设置字体大小
            app.DecompressButton.FontColor = [1, 0, 0];  % 设置字体颜色为红色
            app.DecompressButton.Visible = 'off';
            
            %创建保存编码按钮
            app.SaveCodeButton = uibutton(app.UIFigure, 'push');
            app.SaveCodeButton.ButtonPushedFcn = createCallbackFcn(app, @SaveCode_Callback, true);
            app.SaveCodeButton.FontName = '宋体';
            app.SaveCodeButton.FontSize = 12;
            app.SaveCodeButton.Position = [1160 532 70 40];
            app.SaveCodeButton.Text = '导出';
            app.SaveCodeButton.Visible = 'off';
            
            %创建保存编码按钮
            app.ImportButton = uibutton(app.UIFigure, 'push');
            app.ImportButton.ButtonPushedFcn = createCallbackFcn(app, @Import_Callback, true);
            app.ImportButton.FontName = '宋体';
            app.ImportButton.FontSize = 12;
            app.ImportButton.Position = [50 532 70 40];
            app.ImportButton.Text = '导入';
            
            % 创建标签
            app.CodeLabel = uilabel(app.UIFigure);
            app.CodeLabel.Text = '  下面是编码区域 ： ';
            app.CodeLabel.Position = [860, 656, 400, 40];
            app.CodeLabel.FontSize = 24;
            app.CodeLabel.FontColor = [0.1, 0.5, 0.4]; % RGB颜色值，可以根据需要调整
            
            % 创建显示编码结果的文本区域
            app.EncodedTextArea = uitextarea(app.UIFigure);
            app.EncodedTextArea.Position = [750, 30, 480, 500];
            app.EncodedTextArea.Editable = 'off';
            
            % 设置字体相关属性
            app.EncodedTextArea.FontName = 'Consolas';  % 设置字体为 Consolas
            app.EncodedTextArea.FontSize = 13;  % 设置字体大小
            app.EncodedTextArea.FontWeight = 'bold';  % 加粗
            app.EncodedTextArea.FontAngle = 'italic';  % 加黑
            
            app.EfficiencyLabel = uilabel(app.UIFigure);
            app.EfficiencyLabel.Text = '编码效率为 ：  ';
            app.EfficiencyLabel.Position = [900, 560, 200, 40];
            app.EfficiencyLabel.FontSize = 16;
            app.EfficiencyLabel.FontColor = [0.1, 0.8, 0.4]; % RGB颜色值，可以根据需要调整
            app.EfficiencyLabel.Visible = 'off';
            
            app.avgLenLabel = uilabel(app.UIFigure);
            app.avgLenLabel.Text = '平均码长为 ：  ';
            app.avgLenLabel.Position = [1050, 600, 200, 20];
            app.avgLenLabel.FontSize = 16;
            app.avgLenLabel.FontColor = [0.1, 0.8, 0.4]; % RGB颜色值，可以根据需要调整
            app.avgLenLabel.Visible = 'off';
            
            app.HxLabel = uilabel(app.UIFigure);
            app.HxLabel.Text = '熵(平均自信息量) 为 ：  ';
            app.HxLabel.Position = [800, 600, 300, 20];
            app.HxLabel.FontSize = 16;
            app.HxLabel.FontColor = [0.1, 0.8, 0.4]; % RGB颜色值，可以根据需要调整
            app.HxLabel.Visible = 'off';
            
            % Create Label
            app.inputFormLabel = uilabel(app.UIFigure);
            app.inputFormLabel.HorizontalAlignment = 'right';
            app.inputFormLabel.Position = [35 590 80 22];
            app.inputFormLabel.FontSize = 16;
            app.inputFormLabel.Text = '输入形式 : ';
            
            % Create DropDown
            app.inputFormDropDown = uidropdown(app.UIFigure);
            app.inputFormDropDown.Items = {'文本', '信源符号概率'};
            app.inputFormDropDown.Position = [125 588 120 22];
            app.inputFormDropDown.ValueChangedFcn = createCallbackFcn(app, @inputDropDownValueChanged, true);
            app.inputFormDropDown.Value = '文本';
            app.inputFormDropDown.FontSize = 14;
            
            % Create Label
            app.codeFormLabel = uilabel(app.UIFigure);
            app.codeFormLabel.HorizontalAlignment = 'right';
            app.codeFormLabel.Position = [250 590 80 22];
            app.codeFormLabel.FontSize = 16;
            app.codeFormLabel.Text = '编码方式 : ';
            
            % Create DropDown
            app.codeFormDropDown = uidropdown(app.UIFigure);
            app.codeFormDropDown.Items = {'香农(Shannon)编码', '费诺(Fano)编码','哈夫曼(Huffman)编码'};
            app.codeFormDropDown.Position = [330 588 170 22];
            app.codeFormDropDown.ValueChangedFcn = createCallbackFcn(app, @codeDropDownValueChanged, true);
            app.codeFormDropDown.Value = '香农(Shannon)编码';
            app.codeFormDropDown.FontSize = 14;
            
            % Create Label_Name
            app.Label_Name = uilabel(app.UIFigure);
            app.Label_Name.FontWeight = 'bold';
            app.Label_Name.FontColor = [0.118 0.565 1]; % 深海蓝色
            app.Label_Name.Position = [1150 650 400 200];
            app.Label_Name.FontName = '宋体';
            app.Label_Name.FontSize = 18;
            app.Label_Name.Text = '班级姓名';
            
            % Create Label_Number
            app.Label_ID = uilabel(app.UIFigure);
            app.Label_ID.FontWeight = 'bold';
            app.Label_ID.FontColor = [0.118 0.565 1]; % 深海蓝色
            app.Label_ID.Position = [1150 620 400 200];
            app.Label_ID.FontName = 'Consolas';
            app.Label_ID.FontSize = 18;
            app.Label_ID.Text = ' 学号';
            
            % Create Label_InputInfo
            app.Label_InputInfo = uilabel(app.UIFigure);
            app.Label_InputInfo.FontWeight = 'bold';
            app.Label_InputInfo.FontColor = [0.118 0.565 1]; % 深海蓝色
            app.Label_InputInfo.Position = [880 630 400 20];
            app.Label_InputInfo.FontName = 'Consolas';
            app.Label_InputInfo.FontSize = 16;
            app.Label_InputInfo.Text = '输入信息统计: ';
            app.Label_InputInfo.Visible = 'off';
            
            % Create Label_TextLen
            app.Label_TextLen = uilabel(app.UIFigure);
            app.Label_TextLen.FontWeight = 'bold';
            app.Label_TextLen.FontColor = [0.118 0.565 1]; % 深海蓝色
            app.Label_TextLen.Position = [1000 630 400 20];
            app.Label_TextLen.FontName = 'Consolas';
            app.Label_TextLen.FontSize = 16;
            app.Label_TextLen.Text = '文本长度为 ';
            app.Label_TextLen.Visible = 'off';
            
            % Create Label_TextLen
            app.Label_CompressTextLen = uilabel(app.UIFigure);
            app.Label_CompressTextLen.FontWeight = 'bold';
            app.Label_CompressTextLen.FontColor = [0.118 0.565 1]; % 深海蓝色
            app.Label_CompressTextLen.Position = [1000 580 490 20];
            app.Label_CompressTextLen.FontName = 'Consolas';
            app.Label_CompressTextLen.FontSize = 16;
            app.Label_CompressTextLen.Text = '压缩后文本长度为 ';
            app.Label_CompressTextLen.Visible = 'off';
            
            % Create Label
            app.ModeLabel = uilabel(app.UIFigure);
            app.ModeLabel.HorizontalAlignment = 'right';
            app.ModeLabel.Position = [30 745 100 25];
            app.ModeLabel.FontSize = 20;
            app.ModeLabel.Text = '模式选择 : ';
            app.ModeLabel.FontWeight = 'bold';
            
            % Create DropDown
            app.ModeDropDown = uidropdown(app.UIFigure);
            app.ModeDropDown.Items = {'编码', '加密','压缩'};
            app.ModeDropDown.Position = [140 745 100 22];
            app.ModeDropDown.ValueChangedFcn = createCallbackFcn(app, @ModeDropDownValueChanged, true);
            app.ModeDropDown.Value = '编码';
            app.ModeDropDown.FontSize = 14;
            app.ModeDropDown.FontWeight = 'bold';
            
            % 将窗口显示出来
            app.UIFigure.Visible = 'on';
            
        end
    end
    
    % App生成与删除
    methods (Access = public)
        
        % Construct app
        function app = InformationTheoryWork
            % 创建组件
            createComponents(app);
            
        end
        
        % Code that executes before app deletion
        function delete(app)
            % 删除UIFigure时，将窗口关闭
            delete(app.UIFigure);
        end
    end
    
end