$(TARGET) : $(TARGET).tab.c  lex.yy.c
	g++ $(CFLAGS) $(TARGET).tab.c lex.yy.c -o $(TARGET)

$(TARGET).tab.c: $(TARGET).y
	bison -d -v $(TARGET).y -o $(TARGET).tab.c

lex.yy.c : $(TARGET).l
	flex $(TARGET).l

clean : 
	$(RM) $(TARGET) $(TARGET).tab.c $(TARGET).tab.h lex.yy.c $(TARGET).output
