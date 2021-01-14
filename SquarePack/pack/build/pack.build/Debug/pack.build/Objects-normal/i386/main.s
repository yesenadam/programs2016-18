	.stabs	"/Users/admin/pack/",100,0,4,Ltext0
	.stabs	"/Users/admin/pack/main.cpp",100,0,4,Ltext0
	.text
Ltext0:
	.stabs	"",102,0,0,0
	.stabs	"gcc2_compiled.",60,0,0,0
	.stabs	":t(0,1)=(0,1)",128,0,0,0
.globl _c
	.data
	.align 2
_c:
	.space 4
.globl _v
.zerofill __DATA, __common, _v, 88, 5
	.mod_init_func
	.align 2
	.long	__GLOBAL__I_v
.lcomm __ZSt8__ioinit,1,0
	.section __TEXT,__textcoal_nt,coalesced,pure_instructions
	.align 1
.globl __Z4Usedi
	.weak_definition __Z4Usedi
__Z4Usedi:
	.stabd	46,0,0
	.stabd	68,0,12
LFB1447:
	nop
	nop
	nop
	nop
	nop
	nop
	pushl	%ebp
LCFI0:
	movl	%esp, %ebp
LCFI1:
	pushl	%ebx
LCFI2:
	subl	$36, %esp
LCFI3:
	call	___i686.get_pc_thunk.bx
"L00000000001$pb":
LBB2:
LBB3:
	.stabd	68,0,13
	movl	$1, -12(%ebp)
	jmp	L2
L3:
	.stabd	68,0,14
	movl	-12(%ebp), %edx
	leal	L_v$non_lazy_ptr-"L00000000001$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %ecx
	movl	8(%ebp), %edx
	leal	L_v$non_lazy_ptr-"L00000000001$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	cmpl	%eax, %ecx
	jne	L4
	.stabd	68,0,15
	movl	$1, -28(%ebp)
	jmp	L6
L4:
	.stabd	68,0,13
	leal	-12(%ebp), %eax
	addl	$1, (%eax)
L2:
	movl	-12(%ebp), %eax
	cmpl	8(%ebp), %eax
	jl	L3
LBE3:
	.stabd	68,0,19
	movl	$0, -28(%ebp)
L6:
	movl	-28(%ebp), %eax
LBE2:
	.stabd	68,0,20
	addl	$36, %esp
	popl	%ebx
	popl	%ebp
	ret
LFE1447:
	.stabs	"_Z4Usedi:F(0,2)",36,0,12,__Z4Usedi
	.stabs	"ind:p(0,3)",160,0,12,8
	.stabs	"j:(0,3)",128,0,13,-12
	.stabs	"int:t(0,3)=r(0,3);-2147483648;2147483647;",128,0,0,0
	.stabs	"bool:t(0,2)=@s8;-16;",128,0,0,0
	.stabn	192,0,0,LBB3
	.stabn	224,0,0,LBE3
Lscope0:
	.stabs	"",36,0,0,Lscope0-__Z4Usedi
	.stabd	78,0,0
	.cstring
LC0:
	.ascii "\12\0"
LC1:
	.ascii " \0"
	.text
	.align 1,0x90
.globl __Z4Showi
__Z4Showi:
	.stabd	46,0,0
	.stabd	68,0,22
LFB1448:
	nop
	nop
	nop
	nop
	nop
	nop
	pushl	%ebp
LCFI4:
	movl	%esp, %ebp
LCFI5:
	pushl	%ebx
LCFI6:
	subl	$36, %esp
LCFI7:
	call	___i686.get_pc_thunk.bx
"L00000000002$pb":
LBB4:
	.stabd	68,0,23
	leal	LC0-"L00000000002$pb"(%ebx), %eax
	movl	%eax, 4(%esp)
	leal	L__ZSt4cout$non_lazy_ptr-"L00000000002$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	L__ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc$stub
LBB5:
	.stabd	68,0,24
	movl	$1, -16(%ebp)
	jmp	L10
L11:
LBB6:
	.stabd	68,0,25
	movl	$1, -12(%ebp)
	jmp	L12
L13:
	.stabd	68,0,26
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$3, %eax
	subl	%edx, %eax
	addl	-16(%ebp), %eax
	leal	-7(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000002$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	movl	%eax, 4(%esp)
	leal	L__ZSt4cout$non_lazy_ptr-"L00000000002$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	L__ZNSolsEi$stub
	movl	%eax, %edx
	leal	LC1-"L00000000002$pb"(%ebx), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	L__ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc$stub
	.stabd	68,0,25
	leal	-12(%ebp), %eax
	addl	$1, (%eax)
L12:
	cmpl	$3, -12(%ebp)
	jle	L13
LBE6:
	.stabd	68,0,28
	leal	LC0-"L00000000002$pb"(%ebx), %eax
	movl	%eax, 4(%esp)
	leal	L__ZSt4cout$non_lazy_ptr-"L00000000002$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	L__ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc$stub
	.stabd	68,0,24
	leal	-16(%ebp), %eax
	addl	$1, (%eax)
L10:
	cmpl	$7, -16(%ebp)
	jle	L11
LBE5:
	.stabd	68,0,30
	leal	LC0-"L00000000002$pb"(%ebx), %eax
	movl	%eax, 4(%esp)
	leal	L__ZSt4cout$non_lazy_ptr-"L00000000002$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	L__ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc$stub
	.stabd	68,0,31
	leal	L_c$non_lazy_ptr-"L00000000002$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax), %eax
	leal	1(%eax), %edx
	leal	L_c$non_lazy_ptr-"L00000000002$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	%edx, (%eax)
LBE4:
	.stabd	68,0,32
	addl	$36, %esp
	popl	%ebx
	popl	%ebp
	ret
LFE1448:
	.stabs	"_Z4Showi:F(0,1)",36,0,22,__Z4Showi
	.stabs	"n:p(0,3)",160,0,22,8
	.stabs	"j:(0,3)",128,0,24,-16
	.stabn	192,0,0,LBB5
	.stabs	"i:(0,3)",128,0,25,-12
	.stabn	192,0,0,LBB6
	.stabn	224,0,0,LBE6
	.stabn	224,0,0,LBE5
Lscope1:
	.stabs	"",36,0,0,Lscope1-__Z4Showi
	.stabd	78,0,0
	.align 1,0x90
.globl __Z8FindVColi
__Z8FindVColi:
	.stabd	46,0,0
	.stabd	68,0,34
LFB1449:
	nop
	nop
	nop
	nop
	nop
	nop
	pushl	%ebp
LCFI8:
	movl	%esp, %ebp
LCFI9:
	pushl	%esi
LCFI10:
	pushl	%ebx
LCFI11:
	subl	$48, %esp
LCFI12:
	call	___i686.get_pc_thunk.bx
"L00000000003$pb":
LBB7:
LBB8:
	.stabd	68,0,35
	movl	8(%ebp), %edx
	movl	%edx, %eax
	sall	$3, %eax
	subl	%edx, %eax
	subl	$6, %eax
	movl	%eax, -24(%ebp)
	.stabd	68,0,36
	movl	-24(%ebp), %edx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	$1, (%eax,%edx,4)
	jmp	L18
L19:
LBB9:
	.stabd	68,0,37
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	L__Z4Usedi$stub
	testb	%al, %al
	jne	L20
	.stabd	68,0,40
	movl	-24(%ebp), %edx
	subl	$7, %edx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %ecx
	movl	-24(%ebp), %edx
	subl	$6, %edx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	addl	%eax, %ecx
	movl	-24(%ebp), %edx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	cmpl	%eax, %ecx
	jle	L20
	.stabd	68,0,42
	movl	$1, -20(%ebp)
	.stabd	68,0,43
	movb	$0, -13(%ebp)
LBB10:
	.stabd	68,0,44
	movl	$1, -12(%ebp)
	jmp	L23
L24:
	.stabd	68,0,46
	movl	-20(%ebp), %eax
	movl	-24(%ebp), %esi
	addl	%eax, %esi
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	-8(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %ecx
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	-7(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	addl	%eax, %ecx
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	-1(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	movl	%ecx, %edx
	subl	%eax, %edx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	%edx, (%eax,%esi,4)
	.stabd	68,0,47
	movl	-20(%ebp), %eax
	movl	-24(%ebp), %edx
	addl	%eax, %edx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	cmpl	$21, %eax
	jg	L25
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	L__Z4Usedi$stub
	testb	%al, %al
	je	L27
L25:
	movb	$1, -26(%ebp)
	jmp	L28
L27:
	movb	$0, -26(%ebp)
L28:
	movzbl	-26(%ebp), %eax
	testb	%al, %al
	je	L29
	movb	$1, -13(%ebp)
	jmp	L31
L29:
	.stabd	68,0,49
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	-7(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %ecx
	movl	-20(%ebp), %eax
	movl	-24(%ebp), %edx
	addl	%eax, %edx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	addl	%eax, %ecx
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	-6(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	cmpl	%eax, %ecx
	jg	L32
	movb	$1, -13(%ebp)
	jmp	L31
L32:
	.stabd	68,0,51
	movl	-12(%ebp), %eax
	addl	%eax, %eax
	addl	$1, %eax
	cmpl	$7, %eax
	jg	L31
	.stabd	68,0,53
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	1(%eax), %esi
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	-7(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %ecx
	movl	-20(%ebp), %eax
	movl	-24(%ebp), %edx
	addl	%eax, %edx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	addl	%eax, %ecx
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	-6(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	movl	%ecx, %edx
	subl	%eax, %edx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	%edx, (%eax,%esi,4)
	.stabd	68,0,54
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	1(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	cmpl	$21, %eax
	jg	L35
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	addl	$1, %eax
	movl	%eax, (%esp)
	call	L__Z4Usedi$stub
	testb	%al, %al
	je	L37
L35:
	movb	$1, -25(%ebp)
	jmp	L38
L37:
	movb	$0, -25(%ebp)
L38:
	movzbl	-25(%ebp), %eax
	testb	%al, %al
	je	L39
	movb	$1, -13(%ebp)
	jmp	L31
L39:
	.stabd	68,0,56
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	1(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %esi
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	-6(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %ecx
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	-4(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	leal	(%ecx,%eax), %eax
	subl	$1, %eax
	cmpl	%eax, %esi
	jle	L41
	movb	$1, -13(%ebp)
	jmp	L31
L41:
	.stabd	68,0,57
	leal	-20(%ebp), %eax
	addl	$2, (%eax)
	.stabd	68,0,44
	leal	-12(%ebp), %eax
	addl	$1, (%eax)
L23:
	cmpl	$3, -12(%ebp)
	jle	L24
L31:
LBE10:
	.stabd	68,0,59
	cmpb	$0, -13(%ebp)
	jne	L20
	.stabd	68,0,62
	cmpl	$3, 8(%ebp)
	jne	L44
	movl	$21, (%esp)
	call	__Z4Showi
	jmp	L20
L44:
	movl	8(%ebp), %eax
	addl	$1, %eax
	movl	%eax, (%esp)
	call	__Z8FindHColi
L20:
LBE9:
	.stabd	68,0,36
	movl	-24(%ebp), %ecx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%ecx,4), %eax
	leal	1(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	%edx, (%eax,%ecx,4)
L18:
	movl	-24(%ebp), %eax
	leal	L_v$non_lazy_ptr-"L00000000003$pb"(%ebx), %edx
	movl	(%edx), %edx
	movl	(%edx,%eax,4), %eax
	cmpl	$21, %eax
	jle	L19
LBE8:
LBE7:
	.stabd	68,0,64
	addl	$48, %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
LFE1449:
	.stabs	"_Z8FindVColi:F(0,1)",36,0,34,__Z8FindVColi
	.stabs	"col:p(0,3)",160,0,34,8
	.stabs	"x:(0,3)",128,0,35,-24
	.stabn	192,0,0,LBB8
	.stabs	"offs:(0,3)",128,0,42,-20
	.stabs	"RESTARTCOL:(0,2)",128,0,43,-13
	.stabs	"bool:t(0,2)",128,0,0,0
	.stabn	192,0,0,LBB9
	.stabs	"k:(0,3)",128,0,44,-12
	.stabn	192,0,0,LBB10
	.stabn	224,0,0,LBE10
	.stabn	224,0,0,LBE9
	.stabn	224,0,0,LBE8
Lscope2:
	.stabs	"",36,0,0,Lscope2-__Z8FindVColi
	.stabd	78,0,0
	.align 1,0x90
.globl __Z8FindHColi
__Z8FindHColi:
	.stabd	46,0,0
	.stabd	68,0,66
LFB1450:
	nop
	nop
	nop
	nop
	nop
	nop
	pushl	%ebp
LCFI13:
	movl	%esp, %ebp
LCFI14:
	pushl	%esi
LCFI15:
	pushl	%ebx
LCFI16:
	subl	$48, %esp
LCFI17:
	call	___i686.get_pc_thunk.bx
"L00000000004$pb":
LBB11:
LBB12:
	.stabd	68,0,67
	movl	8(%ebp), %edx
	movl	%edx, %eax
	sall	$3, %eax
	subl	%edx, %eax
	subl	$6, %eax
	movl	%eax, -24(%ebp)
	.stabd	68,0,68
	movl	-24(%ebp), %edx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	$1, (%eax,%edx,4)
	jmp	L49
L50:
LBB13:
	.stabd	68,0,69
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	L__Z4Usedi$stub
	testb	%al, %al
	jne	L51
	.stabd	68,0,72
	movl	-24(%ebp), %edx
	subl	$7, %edx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %ecx
	movl	-24(%ebp), %edx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	addl	%eax, %ecx
	movl	-24(%ebp), %edx
	subl	$6, %edx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	cmpl	%eax, %ecx
	jle	L51
	.stabd	68,0,74
	movl	$1, -20(%ebp)
	.stabd	68,0,75
	movb	$0, -13(%ebp)
LBB14:
	.stabd	68,0,76
	movl	$1, -12(%ebp)
	jmp	L54
L55:
	.stabd	68,0,78
	movl	-20(%ebp), %eax
	movl	-24(%ebp), %esi
	addl	%eax, %esi
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	-8(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %ecx
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	-1(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	addl	%eax, %ecx
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	-7(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	movl	%ecx, %edx
	subl	%eax, %edx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	%edx, (%eax,%esi,4)
	.stabd	68,0,79
	movl	-20(%ebp), %eax
	movl	-24(%ebp), %edx
	addl	%eax, %edx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	cmpl	$21, %eax
	jg	L56
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	L__Z4Usedi$stub
	testb	%al, %al
	je	L58
L56:
	movb	$1, -26(%ebp)
	jmp	L59
L58:
	movb	$0, -26(%ebp)
L59:
	movzbl	-26(%ebp), %eax
	testb	%al, %al
	je	L60
	movb	$1, -13(%ebp)
	jmp	L62
L60:
	.stabd	68,0,81
	movl	-20(%ebp), %eax
	movl	-24(%ebp), %edx
	addl	%eax, %edx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %esi
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	-7(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %ecx
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	-5(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	leal	(%ecx,%eax), %eax
	subl	$1, %eax
	cmpl	%eax, %esi
	jle	L63
	movb	$1, -13(%ebp)
	jmp	L62
L63:
	.stabd	68,0,83
	movl	-12(%ebp), %eax
	addl	%eax, %eax
	addl	$1, %eax
	cmpl	$7, %eax
	jg	L62
	.stabd	68,0,85
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	1(%eax), %esi
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	-7(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %ecx
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	-6(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	addl	%eax, %ecx
	movl	-20(%ebp), %eax
	movl	-24(%ebp), %edx
	addl	%eax, %edx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	movl	%ecx, %edx
	subl	%eax, %edx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	%edx, (%eax,%esi,4)
	.stabd	68,0,86
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	1(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	cmpl	$21, %eax
	jg	L66
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	addl	$1, %eax
	movl	%eax, (%esp)
	call	L__Z4Usedi$stub
	testb	%al, %al
	je	L68
L66:
	movb	$1, -25(%ebp)
	jmp	L69
L68:
	movb	$0, -25(%ebp)
L69:
	movzbl	-25(%ebp), %eax
	testb	%al, %al
	je	L70
	movb	$1, -13(%ebp)
	jmp	L62
L70:
	.stabd	68,0,88
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	-6(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %ecx
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	1(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	addl	%eax, %ecx
	movl	-20(%ebp), %eax
	addl	-24(%ebp), %eax
	leal	-5(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%edx,4), %eax
	cmpl	%eax, %ecx
	jg	L72
	movb	$1, -13(%ebp)
	jmp	L62
L72:
	.stabd	68,0,89
	leal	-20(%ebp), %eax
	addl	$2, (%eax)
	.stabd	68,0,76
	leal	-12(%ebp), %eax
	addl	$1, (%eax)
L54:
	cmpl	$3, -12(%ebp)
	jle	L55
L62:
LBE14:
	.stabd	68,0,91
	cmpb	$0, -13(%ebp)
	jne	L51
	.stabd	68,0,94
	cmpl	$3, 8(%ebp)
	jne	L75
	movl	$21, (%esp)
	call	__Z4Showi
	jmp	L51
L75:
	movl	8(%ebp), %eax
	addl	$1, %eax
	movl	%eax, (%esp)
	call	__Z8FindVColi
L51:
LBE13:
	.stabd	68,0,68
	movl	-24(%ebp), %ecx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%ecx,4), %eax
	leal	1(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	%edx, (%eax,%ecx,4)
L49:
	movl	-24(%ebp), %eax
	leal	L_v$non_lazy_ptr-"L00000000004$pb"(%ebx), %edx
	movl	(%edx), %edx
	movl	(%edx,%eax,4), %eax
	cmpl	$21, %eax
	jle	L50
LBE12:
LBE11:
	.stabd	68,0,96
	addl	$48, %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
LFE1450:
	.stabs	"_Z8FindHColi:F(0,1)",36,0,66,__Z8FindHColi
	.stabs	"col:p(0,3)",160,0,66,8
	.stabs	"x:(0,3)",128,0,67,-24
	.stabn	192,0,0,LBB12
	.stabs	"offs:(0,3)",128,0,74,-20
	.stabs	"RESTARTCOL:(0,2)",128,0,75,-13
	.stabn	192,0,0,LBB13
	.stabs	"k:(0,3)",128,0,76,-12
	.stabn	192,0,0,LBB14
	.stabn	224,0,0,LBE14
	.stabn	224,0,0,LBE13
	.stabn	224,0,0,LBE12
Lscope3:
	.stabs	"",36,0,0,Lscope3-__Z8FindHColi
	.stabd	78,0,0
	.align 1,0x90
.globl __Z12FillFirstColi
__Z12FillFirstColi:
	.stabd	46,0,0
	.stabd	68,0,98
LFB1451:
	nop
	nop
	nop
	nop
	nop
	nop
	pushl	%ebp
LCFI18:
	movl	%esp, %ebp
LCFI19:
	pushl	%ebx
LCFI20:
	subl	$20, %esp
LCFI21:
	call	___i686.get_pc_thunk.bx
"L00000000005$pb":
LBB15:
	.stabd	68,0,99
	movl	8(%ebp), %edx
	leal	L_v$non_lazy_ptr-"L00000000005$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	$1, (%eax,%edx,4)
	jmp	L80
L81:
	.stabd	68,0,100
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	L__Z4Usedi$stub
	testb	%al, %al
	jne	L82
	.stabd	68,0,102
	cmpl	$7, 8(%ebp)
	jne	L84
	movl	$2, (%esp)
	call	__Z8FindHColi
	jmp	L82
L84:
	movl	8(%ebp), %eax
	addl	$1, %eax
	movl	%eax, (%esp)
	call	__Z12FillFirstColi
L82:
	.stabd	68,0,99
	movl	8(%ebp), %ecx
	leal	L_v$non_lazy_ptr-"L00000000005$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax,%ecx,4), %eax
	leal	1(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000005$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	%edx, (%eax,%ecx,4)
L80:
	movl	8(%ebp), %eax
	leal	L_v$non_lazy_ptr-"L00000000005$pb"(%ebx), %edx
	movl	(%edx), %edx
	movl	(%edx,%eax,4), %eax
	cmpl	$21, %eax
	jle	L81
LBE15:
	.stabd	68,0,104
	addl	$20, %esp
	popl	%ebx
	popl	%ebp
	ret
LFE1451:
	.stabs	"_Z12FillFirstColi:F(0,1)",36,0,98,__Z12FillFirstColi
	.stabs	"row:p(0,3)",160,0,98,8
Lscope4:
	.stabs	"",36,0,0,Lscope4-__Z12FillFirstColi
	.stabd	78,0,0
	.cstring
LC2:
	.ascii "\12SquarePack v1\12\0"
LC3:
	.ascii " x \0"
LC4:
	.ascii " packing - \0"
LC5:
	.ascii " squares.\12\0"
LC6:
	.ascii "..\12\0"
LC7:
	.ascii " found.\12\0"
	.text
	.align 1,0x90
.globl _main
_main:
	.stabd	46,0,0
	.stabd	68,0,106
LFB1452:
	nop
	nop
	nop
	nop
	nop
	nop
	pushl	%ebp
LCFI22:
	movl	%esp, %ebp
LCFI23:
	pushl	%ebx
LCFI24:
	subl	$20, %esp
LCFI25:
	call	___i686.get_pc_thunk.bx
"L00000000006$pb":
	.stabd	68,0,107
	leal	LC2-"L00000000006$pb"(%ebx), %eax
	movl	%eax, 4(%esp)
	leal	L__ZSt4cout$non_lazy_ptr-"L00000000006$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	L__ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc$stub
	.stabd	68,0,108
	movl	$3, 4(%esp)
	leal	L__ZSt4cout$non_lazy_ptr-"L00000000006$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	L__ZNSolsEi$stub
	movl	%eax, %edx
	leal	LC3-"L00000000006$pb"(%ebx), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	L__ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc$stub
	movl	$7, 4(%esp)
	movl	%eax, (%esp)
	call	L__ZNSolsEi$stub
	movl	%eax, %edx
	leal	LC4-"L00000000006$pb"(%ebx), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	L__ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc$stub
	movl	$21, 4(%esp)
	movl	%eax, (%esp)
	call	L__ZNSolsEi$stub
	movl	%eax, %edx
	leal	LC5-"L00000000006$pb"(%ebx), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	L__ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc$stub
	.stabd	68,0,109
	leal	L_v$non_lazy_ptr-"L00000000006$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	$1, 4(%eax)
	jmp	L89
L90:
	.stabd	68,0,110
	movl	$2, (%esp)
	call	__Z12FillFirstColi
	.stabd	68,0,111
	leal	L_v$non_lazy_ptr-"L00000000006$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	4(%eax), %eax
	addl	$1, %eax
	movl	%eax, 4(%esp)
	leal	L__ZSt4cout$non_lazy_ptr-"L00000000006$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	L__ZNSolsEi$stub
	movl	%eax, %edx
	leal	LC6-"L00000000006$pb"(%ebx), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	L__ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc$stub
	.stabd	68,0,109
	leal	L_v$non_lazy_ptr-"L00000000006$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	4(%eax), %eax
	leal	1(%eax), %edx
	leal	L_v$non_lazy_ptr-"L00000000006$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	%edx, 4(%eax)
L89:
	leal	L_v$non_lazy_ptr-"L00000000006$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	4(%eax), %eax
	cmpl	$21, %eax
	jle	L90
	.stabd	68,0,113
	leal	L_c$non_lazy_ptr-"L00000000006$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	(%eax), %eax
	movl	%eax, 4(%esp)
	leal	L__ZSt4cout$non_lazy_ptr-"L00000000006$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	L__ZNSolsEi$stub
	movl	%eax, %edx
	leal	LC7-"L00000000006$pb"(%ebx), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	L__ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc$stub
	.stabd	68,0,114
	movl	$0, %eax
	.stabd	68,0,115
	addl	$20, %esp
	popl	%ebx
	popl	%ebp
	ret
LFE1452:
	.stabs	"main:F(0,3)",36,0,106,_main
	.stabs	"argc:p(0,3)",160,0,106,8
	.stabs	"argv:p(0,4)",160,0,106,12
	.stabs	":t(0,4)=*(0,5)",128,0,0,0
	.stabs	":t(0,5)=k(0,6)",128,0,0,0
	.stabs	":t(0,6)=*(0,7)",128,0,0,0
	.stabs	"char:t(0,7)=r(0,7);0;127;",128,0,0,0
Lscope5:
	.stabs	"",36,0,0,Lscope5-_main
	.stabd	78,0,0
	.align 1,0x90
___tcf_0:
	.stabd	46,0,0
	.stabs	"/Developer/SDKs/MacOSX10.4u.sdk/usr/include/c++/4.0.0/iostream",132,0,0,Ltext1
Ltext1:
	.stabd	68,0,76
LFB1461:
	nop
	nop
	nop
	nop
	nop
	nop
	pushl	%ebp
LCFI26:
	movl	%esp, %ebp
LCFI27:
	pushl	%ebx
LCFI28:
	subl	$20, %esp
LCFI29:
	call	___i686.get_pc_thunk.bx
"L00000000007$pb":
	.stabd	68,0,76
	leal	L__ZSt8__ioinit$non_lazy_ptr-"L00000000007$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	L__ZNSt8ios_base4InitD1Ev$stub
	addl	$20, %esp
	popl	%ebx
	popl	%ebp
	ret
LFE1461:
	.stabs	"__tcf_0:f(0,1)",36,0,76,___tcf_0
Lscope6:
	.stabs	"",36,0,0,Lscope6-___tcf_0
	.stabd	78,0,0
	.section __TEXT,__StaticInit,regular,pure_instructions
	.align 1
__Z41__static_initialization_and_destruction_0ii:
	.stabd	46,0,0
	.stabs	"/Users/admin/pack/main.cpp",132,0,0,Ltext2
Ltext2:
	.stabd	68,0,115
LFB1460:
	nop
	nop
	nop
	nop
	nop
	nop
	pushl	%ebp
LCFI30:
	movl	%esp, %ebp
LCFI31:
	pushl	%ebx
LCFI32:
	subl	$36, %esp
LCFI33:
	call	___i686.get_pc_thunk.bx
"L00000000008$pb":
	movl	%eax, -12(%ebp)
	movl	%edx, -16(%ebp)
	.stabs	"/Developer/SDKs/MacOSX10.4u.sdk/usr/include/c++/4.0.0/iostream",132,0,0,Ltext3
Ltext3:
	.stabd	68,0,76
	cmpl	$65535, -16(%ebp)
	jne	L99
	cmpl	$1, -12(%ebp)
	jne	L99
	leal	L__ZSt8__ioinit$non_lazy_ptr-"L00000000008$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	L__ZNSt8ios_base4InitC1Ev$stub
	leal	L___dso_handle$non_lazy_ptr-"L00000000008$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	%eax, 8(%esp)
	movl	$0, 4(%esp)
	leal	L___tcf_0$non_lazy_ptr-"L00000000008$pb"(%ebx), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	L___cxa_atexit$stub
L99:
	.stabs	"/Users/admin/pack/main.cpp",132,0,0,Ltext4
Ltext4:
	.stabd	68,0,115
	addl	$36, %esp
	popl	%ebx
	popl	%ebp
	ret
LFE1460:
	.stabs	"_Z41__static_initialization_and_destruction_0ii:f(0,1)",36,0,115,__Z41__static_initialization_and_destruction_0ii
	.stabs	"__initialize_p:p(0,3)",160,0,115,-12
	.stabs	"__priority:p(0,3)",160,0,115,-16
Lscope7:
	.stabs	"",36,0,0,Lscope7-__Z41__static_initialization_and_destruction_0ii
	.stabd	78,0,0
	.align 1
__GLOBAL__I_v:
	.stabd	46,0,0
	.stabd	68,0,116
LFB1462:
	nop
	nop
	nop
	nop
	nop
	nop
	pushl	%ebp
LCFI34:
	movl	%esp, %ebp
LCFI35:
	subl	$8, %esp
LCFI36:
	.stabd	68,0,116
	movl	$65535, %edx
	movl	$1, %eax
	call	__Z41__static_initialization_and_destruction_0ii
	leave
	ret
LFE1462:
	.stabs	"_GLOBAL__I_v:f(0,1)",36,0,116,__GLOBAL__I_v
Lscope8:
	.stabs	"",36,0,0,Lscope8-__GLOBAL__I_v
	.stabd	78,0,0
	.stabs	"v:G(0,8)",32,0,9,0
	.stabs	"c:G(0,3)",32,0,10,0
	.stabs	":t(0,8)=ar(0,9);0;21;(0,3)",128,0,0,0
	.stabs	"long unsigned int:t(0,9)=r(0,9);0;037777777777;",128,0,0,0
	.stabs	"_ZSt8__ioinit:S(0,10)=xsInit:",40,0,76,__ZSt8__ioinit
	.stabs	"ios_base::Init:Tt(0,10)=s1_S_refcount:/0(0,11):_ZNSt8ios_base4Init11_S_refcountE;_S_synced_with_stdio:/0(0,2):_ZNSt8ios_base4Init20_S_synced_with_stdioE;__base_ctor ::(0,12)=#(0,10),(0,1),(0,13),(0,14),(0,1);:_ZNSt8ios_base4InitC2ERKS0_;2A.;__comp_ctor ::(0,12):_ZNSt8ios_base4InitC1ERKS0_;2A.;__base_ctor ::(0,15)=#(0,10),(0,1),(0,13),(0,1);:_ZNSt8ios_base4InitC2Ev;2A.;__comp_ctor ::(0,15):_ZNSt8ios_base4InitC1Ev;2A.;__base_dtor ::(0,15):_ZNSt8ios_base4InitD2Ev;2A.;__comp_dtor ::(0,15):_ZNSt8ios_base4InitD1Ev;2A.;;",128,0,531,0
	.stabs	"_Atomic_word:t(0,11)=(0,3)",128,0,0,0
	.stabs	":t(0,13)=*(0,10)",128,0,0,0
	.stabs	":t(0,14)=&(0,16)",128,0,0,0
	.stabs	":t(0,16)=k(0,10)",128,0,0,0
	.section __TEXT,__eh_frame,coalesced,no_toc+strip_static_syms+live_support
EH_frame1:
	.set L$set$0,LECIE1-LSCIE1
	.long L$set$0
LSCIE1:
	.long	0x0
	.byte	0x1
	.ascii "zPR\0"
	.byte	0x1
	.byte	0x7c
	.byte	0x8
	.byte	0x6
	.byte	0x9b
	.long	L___gxx_personality_v0$non_lazy_ptr-.
	.byte	0x10
	.byte	0xc
	.byte	0x5
	.byte	0x4
	.byte	0x88
	.byte	0x1
	.align 2
LECIE1:
	.globl __Z4Usedi.eh
	.weak_definition __Z4Usedi.eh
__Z4Usedi.eh:
LSFDE1:
	.set L$set$1,LEFDE1-LASFDE1
	.long L$set$1
LASFDE1:
	.long	LASFDE1-EH_frame1
	.long	LFB1447-.
	.set L$set$2,LFE1447-LFB1447
	.long L$set$2
	.byte	0x0
	.byte	0x4
	.set L$set$3,LCFI0-LFB1447
	.long L$set$3
	.byte	0xe
	.byte	0x8
	.byte	0x84
	.byte	0x2
	.byte	0x4
	.set L$set$4,LCFI1-LCFI0
	.long L$set$4
	.byte	0xd
	.byte	0x4
	.byte	0x4
	.set L$set$5,LCFI3-LCFI1
	.long L$set$5
	.byte	0x83
	.byte	0x3
	.align 2
LEFDE1:
	.globl __Z4Showi.eh
__Z4Showi.eh:
LSFDE3:
	.set L$set$6,LEFDE3-LASFDE3
	.long L$set$6
LASFDE3:
	.long	LASFDE3-EH_frame1
	.long	LFB1448-.
	.set L$set$7,LFE1448-LFB1448
	.long L$set$7
	.byte	0x0
	.byte	0x4
	.set L$set$8,LCFI4-LFB1448
	.long L$set$8
	.byte	0xe
	.byte	0x8
	.byte	0x84
	.byte	0x2
	.byte	0x4
	.set L$set$9,LCFI5-LCFI4
	.long L$set$9
	.byte	0xd
	.byte	0x4
	.byte	0x4
	.set L$set$10,LCFI7-LCFI5
	.long L$set$10
	.byte	0x83
	.byte	0x3
	.align 2
LEFDE3:
	.globl __Z8FindVColi.eh
__Z8FindVColi.eh:
LSFDE5:
	.set L$set$11,LEFDE5-LASFDE5
	.long L$set$11
LASFDE5:
	.long	LASFDE5-EH_frame1
	.long	LFB1449-.
	.set L$set$12,LFE1449-LFB1449
	.long L$set$12
	.byte	0x0
	.byte	0x4
	.set L$set$13,LCFI8-LFB1449
	.long L$set$13
	.byte	0xe
	.byte	0x8
	.byte	0x84
	.byte	0x2
	.byte	0x4
	.set L$set$14,LCFI9-LCFI8
	.long L$set$14
	.byte	0xd
	.byte	0x4
	.byte	0x4
	.set L$set$15,LCFI12-LCFI9
	.long L$set$15
	.byte	0x83
	.byte	0x4
	.byte	0x86
	.byte	0x3
	.align 2
LEFDE5:
	.globl __Z8FindHColi.eh
__Z8FindHColi.eh:
LSFDE7:
	.set L$set$16,LEFDE7-LASFDE7
	.long L$set$16
LASFDE7:
	.long	LASFDE7-EH_frame1
	.long	LFB1450-.
	.set L$set$17,LFE1450-LFB1450
	.long L$set$17
	.byte	0x0
	.byte	0x4
	.set L$set$18,LCFI13-LFB1450
	.long L$set$18
	.byte	0xe
	.byte	0x8
	.byte	0x84
	.byte	0x2
	.byte	0x4
	.set L$set$19,LCFI14-LCFI13
	.long L$set$19
	.byte	0xd
	.byte	0x4
	.byte	0x4
	.set L$set$20,LCFI17-LCFI14
	.long L$set$20
	.byte	0x83
	.byte	0x4
	.byte	0x86
	.byte	0x3
	.align 2
LEFDE7:
	.globl __Z12FillFirstColi.eh
__Z12FillFirstColi.eh:
LSFDE9:
	.set L$set$21,LEFDE9-LASFDE9
	.long L$set$21
LASFDE9:
	.long	LASFDE9-EH_frame1
	.long	LFB1451-.
	.set L$set$22,LFE1451-LFB1451
	.long L$set$22
	.byte	0x0
	.byte	0x4
	.set L$set$23,LCFI18-LFB1451
	.long L$set$23
	.byte	0xe
	.byte	0x8
	.byte	0x84
	.byte	0x2
	.byte	0x4
	.set L$set$24,LCFI19-LCFI18
	.long L$set$24
	.byte	0xd
	.byte	0x4
	.byte	0x4
	.set L$set$25,LCFI21-LCFI19
	.long L$set$25
	.byte	0x83
	.byte	0x3
	.align 2
LEFDE9:
	.globl _main.eh
_main.eh:
LSFDE11:
	.set L$set$26,LEFDE11-LASFDE11
	.long L$set$26
LASFDE11:
	.long	LASFDE11-EH_frame1
	.long	LFB1452-.
	.set L$set$27,LFE1452-LFB1452
	.long L$set$27
	.byte	0x0
	.byte	0x4
	.set L$set$28,LCFI22-LFB1452
	.long L$set$28
	.byte	0xe
	.byte	0x8
	.byte	0x84
	.byte	0x2
	.byte	0x4
	.set L$set$29,LCFI23-LCFI22
	.long L$set$29
	.byte	0xd
	.byte	0x4
	.byte	0x4
	.set L$set$30,LCFI25-LCFI23
	.long L$set$30
	.byte	0x83
	.byte	0x3
	.align 2
LEFDE11:
___tcf_0.eh:
LSFDE13:
	.set L$set$31,LEFDE13-LASFDE13
	.long L$set$31
LASFDE13:
	.long	LASFDE13-EH_frame1
	.long	LFB1461-.
	.set L$set$32,LFE1461-LFB1461
	.long L$set$32
	.byte	0x0
	.byte	0x4
	.set L$set$33,LCFI26-LFB1461
	.long L$set$33
	.byte	0xe
	.byte	0x8
	.byte	0x84
	.byte	0x2
	.byte	0x4
	.set L$set$34,LCFI27-LCFI26
	.long L$set$34
	.byte	0xd
	.byte	0x4
	.byte	0x4
	.set L$set$35,LCFI29-LCFI27
	.long L$set$35
	.byte	0x83
	.byte	0x3
	.align 2
LEFDE13:
__Z41__static_initialization_and_destruction_0ii.eh:
LSFDE15:
	.set L$set$36,LEFDE15-LASFDE15
	.long L$set$36
LASFDE15:
	.long	LASFDE15-EH_frame1
	.long	LFB1460-.
	.set L$set$37,LFE1460-LFB1460
	.long L$set$37
	.byte	0x0
	.byte	0x4
	.set L$set$38,LCFI30-LFB1460
	.long L$set$38
	.byte	0xe
	.byte	0x8
	.byte	0x84
	.byte	0x2
	.byte	0x4
	.set L$set$39,LCFI31-LCFI30
	.long L$set$39
	.byte	0xd
	.byte	0x4
	.byte	0x4
	.set L$set$40,LCFI33-LCFI31
	.long L$set$40
	.byte	0x83
	.byte	0x3
	.align 2
LEFDE15:
__GLOBAL__I_v.eh:
LSFDE17:
	.set L$set$41,LEFDE17-LASFDE17
	.long L$set$41
LASFDE17:
	.long	LASFDE17-EH_frame1
	.long	LFB1462-.
	.set L$set$42,LFE1462-LFB1462
	.long L$set$42
	.byte	0x0
	.byte	0x4
	.set L$set$43,LCFI34-LFB1462
	.long L$set$43
	.byte	0xe
	.byte	0x8
	.byte	0x84
	.byte	0x2
	.byte	0x4
	.set L$set$44,LCFI35-LCFI34
	.long L$set$44
	.byte	0xd
	.byte	0x4
	.align 2
LEFDE17:
	.text
	.stabs	"",100,0,0,Letext0
Letext0:
	.section __IMPORT,__pointers,non_lazy_symbol_pointers
L__ZSt8__ioinit$non_lazy_ptr:
	.indirect_symbol __ZSt8__ioinit
	.long	__ZSt8__ioinit
	.section __IMPORT,__jump_table,symbol_stubs,self_modifying_code+pure_instructions,5
L___cxa_atexit$stub:
	.indirect_symbol ___cxa_atexit
	hlt ; hlt ; hlt ; hlt ; hlt
	.section __IMPORT,__pointers,non_lazy_symbol_pointers
L_v$non_lazy_ptr:
	.indirect_symbol _v
	.long	0
L__ZSt4cout$non_lazy_ptr:
	.indirect_symbol __ZSt4cout
	.long	0
	.section __IMPORT,__jump_table,symbol_stubs,self_modifying_code+pure_instructions,5
L__ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc$stub:
	.indirect_symbol __ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	hlt ; hlt ; hlt ; hlt ; hlt
	.section __IMPORT,__pointers,non_lazy_symbol_pointers
L_c$non_lazy_ptr:
	.indirect_symbol _c
	.long	0
	.section __IMPORT,__jump_table,symbol_stubs,self_modifying_code+pure_instructions,5
L__ZNSt8ios_base4InitC1Ev$stub:
	.indirect_symbol __ZNSt8ios_base4InitC1Ev
	hlt ; hlt ; hlt ; hlt ; hlt
L__Z4Usedi$stub:
	.indirect_symbol __Z4Usedi
	hlt ; hlt ; hlt ; hlt ; hlt
L__ZNSolsEi$stub:
	.indirect_symbol __ZNSolsEi
	hlt ; hlt ; hlt ; hlt ; hlt
L__ZNSt8ios_base4InitD1Ev$stub:
	.indirect_symbol __ZNSt8ios_base4InitD1Ev
	hlt ; hlt ; hlt ; hlt ; hlt
	.section __IMPORT,__pointers,non_lazy_symbol_pointers
L___gxx_personality_v0$non_lazy_ptr:
	.indirect_symbol ___gxx_personality_v0
	.long	0
L___dso_handle$non_lazy_ptr:
	.indirect_symbol ___dso_handle
	.long	0
L___tcf_0$non_lazy_ptr:
	.indirect_symbol ___tcf_0
	.long	___tcf_0
	.constructor
	.destructor
	.align 1
	.subsections_via_symbols
	.section __TEXT,__textcoal_nt,coalesced,pure_instructions
.weak_definition	___i686.get_pc_thunk.bx
.private_extern	___i686.get_pc_thunk.bx
___i686.get_pc_thunk.bx:
	movl	(%esp), %ebx
	ret
