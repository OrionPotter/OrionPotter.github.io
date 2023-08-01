---
title: Csv工具类
tag: csv
---

## CSV工具类

>近期做的都是数据处理的工作，总结起来就是一些表格的处理，为了方便我将其转换为csv文件，按照csv文件方便快捷的方式进行处理的，总的来说包括以下几个方面
>
>1. 多个csv进行合并成一个文件
>2. csv根据某个字段进行拆分成多个文件，暂时无法通用
>3. 根据合并后的文件的某个字段进行去重处理
>4. 根据某个字段，统计每个字段内容的出现次数

**注意：**这里面还有一些计数操作，只是为了方便以后的复用，不会显示在里面，后续如果的有计数的操作，需要改动代码。

```java
import java.io.*;
import java.util.HashSet;

/**
 * <p>
 * CSV工具类
 * </p>
 *
 * @author potter
 * @Since 2022/05/12  23:14
 */
public class CsvUtil {
    /**
     * 合并多个csv文件不带表头
     * @param targetPath
     * @param sourcePaths
     * @throws IOException
     */
    public static void mergeCsvWithOutTitle(String targetPath,String...sourcePaths) throws IOException {
        BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter(targetPath));
        for (String sourcePath : sourcePaths) {
            BufferedReader bufferedReader = new BufferedReader(new FileReader(sourcePath));
            String str = null;
            long line = 0;
            while ((str = bufferedReader.readLine()) != null) {
                line++;
                if (line == 1) {
                    continue;
                }
                bufferedWriter.write(str);
                bufferedWriter.newLine();
            }
            bufferedReader.close();
        }
        bufferedWriter.flush();
        bufferedWriter.close();
    }
    
     /**
     * 根据某个字段对csv文件进行去重
     * @param filed
     * @param sourcePath
     * @param targetPath
     * @throws IOException
     */
    public static void distinctByFiled(String filed,String sourcePath,String targetPath) throws IOException {
        BufferedReader bufferedReader = new BufferedReader(new FileReader(sourcePath));
        BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter(targetPath));
        /**
         * hashSet存储要被去重的字段
         */
        HashSet<String> hashSet = new HashSet<>();
        String str = null;
        long line = 0;
        while ((str = bufferedReader.readLine()) != null) {
            String[] split = str.trim().split(",(?=([^\\\"]*\\\"[^\\\"]*\\\")*[^\\\"]*$)",-1);
            int column = 0;
            line++;
            if (line == 1) {
                bufferedWriter.write(str);
                bufferedWriter.newLine();
                //获取去重的列号
                for (int i = 0; i < split.length; i++) {
                    if(split[i].equals(filed)){
                        column = i;
                    }
                }
                continue;
            }
            String distinct = split[column];
            if(hashSet.contains(distinct)){
                continue;
            }else {
                hashSet.add(distinct);
            }
            bufferedWriter.write(str);
            bufferedWriter.newLine();
        }
        bufferedWriter.flush();
        bufferedWriter.close();
        bufferedReader.close();
    }
    
    
     /**
     * 根据某个字段，统计每个字段内容的出现次数
     * @param filed
     * @param sourcePath
     * @param targetPath
     * @throws IOException
     */
    public static void countByFiled(String filed,String sourcePath,String targetPath) throws IOException{
        BufferedReader bufferedReader = new BufferedReader(new FileReader(sourcePath));
        BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter(targetPath));

        HashMap<String,Integer> hashMap = new HashMap<>();
        String str = null;
        long line = 0;
        int column = 0;
        while ((str = bufferedReader.readLine()) != null) {
            String[] split = str.trim().split(",(?=([^\\\"]*\\\"[^\\\"]*\\\")*[^\\\"]*$)", -1);
            line++;
            if (line == 1) {
                //获取去重的列号
                for (int i = 0; i < split.length; i++) {
                    if (split[i].equals(filed)) {
                        column = i;
                    }
                }
                continue;
            }
            String count = split[column];
            if(hashMap.containsKey(count)){
                hashMap.put(count, hashMap.get(count)+1);
            }else {
                hashMap.put(count,1);
            }
        }
        bufferedReader.close();

        for (Map.Entry<String, Integer> stringIntegerEntry : hashMap.entrySet()) {
            String key = stringIntegerEntry.getKey();
            Integer value = stringIntegerEntry.getValue();
            bufferedWriter.write(key+","+value);
            bufferedWriter.newLine();
        }
        bufferedWriter.flush();
        bufferedWriter.close();

    }
}
```

