
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8d013103          	ld	sp,-1840(sp) # 800088d0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	42d050ef          	jal	ra,80005c42 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00032797          	auipc	a5,0x32
    80000034:	21078793          	addi	a5,a5,528 # 80032240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	5d0080e7          	jalr	1488(ra) # 8000662a <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	670080e7          	jalr	1648(ra) # 800066de <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	068080e7          	jalr	104(ra) # 800060f2 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	f4250513          	addi	a0,a0,-190 # 80009030 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	4a4080e7          	jalr	1188(ra) # 8000659a <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00032517          	auipc	a0,0x32
    80000106:	13e50513          	addi	a0,a0,318 # 80032240 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	f0c48493          	addi	s1,s1,-244 # 80009030 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	4fc080e7          	jalr	1276(ra) # 8000662a <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	ef450513          	addi	a0,a0,-268 # 80009030 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	598080e7          	jalr	1432(ra) # 800066de <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	ec850513          	addi	a0,a0,-312 # 80009030 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	56e080e7          	jalr	1390(ra) # 800066de <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffccdc1>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	872a                	mv	a4,a0
    8000028e:	8832                	mv	a6,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	01005963          	blez	a6,800002a4 <strncpy+0x1e>
    80000296:	0705                	addi	a4,a4,1
    80000298:	0005c783          	lbu	a5,0(a1)
    8000029c:	fef70fa3          	sb	a5,-1(a4)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f7f5                	bnez	a5,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	86ba                	mv	a3,a4
    800002a6:	00c05c63          	blez	a2,800002be <strncpy+0x38>
    *s++ = 0;
    800002aa:	0685                	addi	a3,a3,1
    800002ac:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b0:	40d707bb          	subw	a5,a4,a3
    800002b4:	37fd                	addiw	a5,a5,-1
    800002b6:	010787bb          	addw	a5,a5,a6
    800002ba:	fef048e3          	bgtz	a5,800002aa <strncpy+0x24>
  return os;
}
    800002be:	6422                	ld	s0,8(sp)
    800002c0:	0141                	addi	sp,sp,16
    800002c2:	8082                	ret

00000000800002c4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c4:	1141                	addi	sp,sp,-16
    800002c6:	e422                	sd	s0,8(sp)
    800002c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ca:	02c05363          	blez	a2,800002f0 <safestrcpy+0x2c>
    800002ce:	fff6069b          	addiw	a3,a2,-1
    800002d2:	1682                	slli	a3,a3,0x20
    800002d4:	9281                	srli	a3,a3,0x20
    800002d6:	96ae                	add	a3,a3,a1
    800002d8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002da:	00d58963          	beq	a1,a3,800002ec <safestrcpy+0x28>
    800002de:	0585                	addi	a1,a1,1
    800002e0:	0785                	addi	a5,a5,1
    800002e2:	fff5c703          	lbu	a4,-1(a1)
    800002e6:	fee78fa3          	sb	a4,-1(a5)
    800002ea:	fb65                	bnez	a4,800002da <safestrcpy+0x16>
    ;
  *s = 0;
    800002ec:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f0:	6422                	ld	s0,8(sp)
    800002f2:	0141                	addi	sp,sp,16
    800002f4:	8082                	ret

00000000800002f6 <strlen>:

int
strlen(const char *s)
{
    800002f6:	1141                	addi	sp,sp,-16
    800002f8:	e422                	sd	s0,8(sp)
    800002fa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fc:	00054783          	lbu	a5,0(a0)
    80000300:	cf91                	beqz	a5,8000031c <strlen+0x26>
    80000302:	0505                	addi	a0,a0,1
    80000304:	87aa                	mv	a5,a0
    80000306:	4685                	li	a3,1
    80000308:	9e89                	subw	a3,a3,a0
    8000030a:	00f6853b          	addw	a0,a3,a5
    8000030e:	0785                	addi	a5,a5,1
    80000310:	fff7c703          	lbu	a4,-1(a5)
    80000314:	fb7d                	bnez	a4,8000030a <strlen+0x14>
    ;
  return n;
}
    80000316:	6422                	ld	s0,8(sp)
    80000318:	0141                	addi	sp,sp,16
    8000031a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031c:	4501                	li	a0,0
    8000031e:	bfe5                	j	80000316 <strlen+0x20>

0000000080000320 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000320:	1141                	addi	sp,sp,-16
    80000322:	e406                	sd	ra,8(sp)
    80000324:	e022                	sd	s0,0(sp)
    80000326:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000328:	00001097          	auipc	ra,0x1
    8000032c:	af2080e7          	jalr	-1294(ra) # 80000e1a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000330:	00009717          	auipc	a4,0x9
    80000334:	cd070713          	addi	a4,a4,-816 # 80009000 <started>
  if(cpuid() == 0){
    80000338:	c139                	beqz	a0,8000037e <main+0x5e>
    while(started == 0)
    8000033a:	431c                	lw	a5,0(a4)
    8000033c:	2781                	sext.w	a5,a5
    8000033e:	dff5                	beqz	a5,8000033a <main+0x1a>
      ;
    __sync_synchronize();
    80000340:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000344:	00001097          	auipc	ra,0x1
    80000348:	ad6080e7          	jalr	-1322(ra) # 80000e1a <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	de6080e7          	jalr	-538(ra) # 8000613c <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00002097          	auipc	ra,0x2
    8000036a:	880080e7          	jalr	-1920(ra) # 80001be6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	2b2080e7          	jalr	690(ra) # 80005620 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	070080e7          	jalr	112(ra) # 800013e6 <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	c84080e7          	jalr	-892(ra) # 80006002 <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	f96080e7          	jalr	-106(ra) # 8000631c <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	da6080e7          	jalr	-602(ra) # 8000613c <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	d96080e7          	jalr	-618(ra) # 8000613c <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	d86080e7          	jalr	-634(ra) # 8000613c <printf>
    kinit();         // physical page allocator
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	d20080e7          	jalr	-736(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	322080e7          	jalr	802(ra) # 800006e8 <kvminit>
    kvminithart();   // turn on paging
    800003ce:	00000097          	auipc	ra,0x0
    800003d2:	068080e7          	jalr	104(ra) # 80000436 <kvminithart>
    procinit();      // process table
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	992080e7          	jalr	-1646(ra) # 80000d68 <procinit>
    trapinit();      // trap vectors
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	7e0080e7          	jalr	2016(ra) # 80001bbe <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00002097          	auipc	ra,0x2
    800003ea:	800080e7          	jalr	-2048(ra) # 80001be6 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	21c080e7          	jalr	540(ra) # 8000560a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	22a080e7          	jalr	554(ra) # 80005620 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	060080e7          	jalr	96(ra) # 8000245e <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	6ee080e7          	jalr	1774(ra) # 80002af4 <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	6a4080e7          	jalr	1700(ra) # 80003ab2 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	32a080e7          	jalr	810(ra) # 80005740 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	d3e080e7          	jalr	-706(ra) # 8000115c <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00009717          	auipc	a4,0x9
    80000430:	bcf72a23          	sw	a5,-1068(a4) # 80009000 <started>
    80000434:	b789                	j	80000376 <main+0x56>

0000000080000436 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000436:	1141                	addi	sp,sp,-16
    80000438:	e422                	sd	s0,8(sp)
    8000043a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000043c:	00009797          	auipc	a5,0x9
    80000440:	bcc7b783          	ld	a5,-1076(a5) # 80009008 <kernel_pagetable>
    80000444:	83b1                	srli	a5,a5,0xc
    80000446:	577d                	li	a4,-1
    80000448:	177e                	slli	a4,a4,0x3f
    8000044a:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000450:	12000073          	sfence.vma
  sfence_vma();
}
    80000454:	6422                	ld	s0,8(sp)
    80000456:	0141                	addi	sp,sp,16
    80000458:	8082                	ret

000000008000045a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045a:	7139                	addi	sp,sp,-64
    8000045c:	fc06                	sd	ra,56(sp)
    8000045e:	f822                	sd	s0,48(sp)
    80000460:	f426                	sd	s1,40(sp)
    80000462:	f04a                	sd	s2,32(sp)
    80000464:	ec4e                	sd	s3,24(sp)
    80000466:	e852                	sd	s4,16(sp)
    80000468:	e456                	sd	s5,8(sp)
    8000046a:	e05a                	sd	s6,0(sp)
    8000046c:	0080                	addi	s0,sp,64
    8000046e:	84aa                	mv	s1,a0
    80000470:	89ae                	mv	s3,a1
    80000472:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000474:	57fd                	li	a5,-1
    80000476:	83e9                	srli	a5,a5,0x1a
    80000478:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047c:	04b7f263          	bgeu	a5,a1,800004c0 <walk+0x66>
    panic("walk");
    80000480:	00008517          	auipc	a0,0x8
    80000484:	bd050513          	addi	a0,a0,-1072 # 80008050 <etext+0x50>
    80000488:	00006097          	auipc	ra,0x6
    8000048c:	c6a080e7          	jalr	-918(ra) # 800060f2 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000490:	060a8663          	beqz	s5,800004fc <walk+0xa2>
    80000494:	00000097          	auipc	ra,0x0
    80000498:	c86080e7          	jalr	-890(ra) # 8000011a <kalloc>
    8000049c:	84aa                	mv	s1,a0
    8000049e:	c529                	beqz	a0,800004e8 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a0:	6605                	lui	a2,0x1
    800004a2:	4581                	li	a1,0
    800004a4:	00000097          	auipc	ra,0x0
    800004a8:	cd6080e7          	jalr	-810(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ac:	00c4d793          	srli	a5,s1,0xc
    800004b0:	07aa                	slli	a5,a5,0xa
    800004b2:	0017e793          	ori	a5,a5,1
    800004b6:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004ba:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffccdb7>
    800004bc:	036a0063          	beq	s4,s6,800004dc <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c0:	0149d933          	srl	s2,s3,s4
    800004c4:	1ff97913          	andi	s2,s2,511
    800004c8:	090e                	slli	s2,s2,0x3
    800004ca:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004cc:	00093483          	ld	s1,0(s2)
    800004d0:	0014f793          	andi	a5,s1,1
    800004d4:	dfd5                	beqz	a5,80000490 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d6:	80a9                	srli	s1,s1,0xa
    800004d8:	04b2                	slli	s1,s1,0xc
    800004da:	b7c5                	j	800004ba <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004dc:	00c9d513          	srli	a0,s3,0xc
    800004e0:	1ff57513          	andi	a0,a0,511
    800004e4:	050e                	slli	a0,a0,0x3
    800004e6:	9526                	add	a0,a0,s1
}
    800004e8:	70e2                	ld	ra,56(sp)
    800004ea:	7442                	ld	s0,48(sp)
    800004ec:	74a2                	ld	s1,40(sp)
    800004ee:	7902                	ld	s2,32(sp)
    800004f0:	69e2                	ld	s3,24(sp)
    800004f2:	6a42                	ld	s4,16(sp)
    800004f4:	6aa2                	ld	s5,8(sp)
    800004f6:	6b02                	ld	s6,0(sp)
    800004f8:	6121                	addi	sp,sp,64
    800004fa:	8082                	ret
        return 0;
    800004fc:	4501                	li	a0,0
    800004fe:	b7ed                	j	800004e8 <walk+0x8e>

0000000080000500 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000500:	57fd                	li	a5,-1
    80000502:	83e9                	srli	a5,a5,0x1a
    80000504:	00b7f463          	bgeu	a5,a1,8000050c <walkaddr+0xc>
    return 0;
    80000508:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050a:	8082                	ret
{
    8000050c:	1141                	addi	sp,sp,-16
    8000050e:	e406                	sd	ra,8(sp)
    80000510:	e022                	sd	s0,0(sp)
    80000512:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000514:	4601                	li	a2,0
    80000516:	00000097          	auipc	ra,0x0
    8000051a:	f44080e7          	jalr	-188(ra) # 8000045a <walk>
  if(pte == 0)
    8000051e:	c105                	beqz	a0,8000053e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000520:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000522:	0117f693          	andi	a3,a5,17
    80000526:	4745                	li	a4,17
    return 0;
    80000528:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052a:	00e68663          	beq	a3,a4,80000536 <walkaddr+0x36>
}
    8000052e:	60a2                	ld	ra,8(sp)
    80000530:	6402                	ld	s0,0(sp)
    80000532:	0141                	addi	sp,sp,16
    80000534:	8082                	ret
  pa = PTE2PA(*pte);
    80000536:	83a9                	srli	a5,a5,0xa
    80000538:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000053c:	bfcd                	j	8000052e <walkaddr+0x2e>
    return 0;
    8000053e:	4501                	li	a0,0
    80000540:	b7fd                	j	8000052e <walkaddr+0x2e>

0000000080000542 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000542:	715d                	addi	sp,sp,-80
    80000544:	e486                	sd	ra,72(sp)
    80000546:	e0a2                	sd	s0,64(sp)
    80000548:	fc26                	sd	s1,56(sp)
    8000054a:	f84a                	sd	s2,48(sp)
    8000054c:	f44e                	sd	s3,40(sp)
    8000054e:	f052                	sd	s4,32(sp)
    80000550:	ec56                	sd	s5,24(sp)
    80000552:	e85a                	sd	s6,16(sp)
    80000554:	e45e                	sd	s7,8(sp)
    80000556:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000558:	c639                	beqz	a2,800005a6 <mappages+0x64>
    8000055a:	8aaa                	mv	s5,a0
    8000055c:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000055e:	777d                	lui	a4,0xfffff
    80000560:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000564:	fff58993          	addi	s3,a1,-1
    80000568:	99b2                	add	s3,s3,a2
    8000056a:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000056e:	893e                	mv	s2,a5
    80000570:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000574:	6b85                	lui	s7,0x1
    80000576:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057a:	4605                	li	a2,1
    8000057c:	85ca                	mv	a1,s2
    8000057e:	8556                	mv	a0,s5
    80000580:	00000097          	auipc	ra,0x0
    80000584:	eda080e7          	jalr	-294(ra) # 8000045a <walk>
    80000588:	cd1d                	beqz	a0,800005c6 <mappages+0x84>
    if(*pte & PTE_V)
    8000058a:	611c                	ld	a5,0(a0)
    8000058c:	8b85                	andi	a5,a5,1
    8000058e:	e785                	bnez	a5,800005b6 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000590:	80b1                	srli	s1,s1,0xc
    80000592:	04aa                	slli	s1,s1,0xa
    80000594:	0164e4b3          	or	s1,s1,s6
    80000598:	0014e493          	ori	s1,s1,1
    8000059c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000059e:	05390063          	beq	s2,s3,800005de <mappages+0x9c>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	bfc9                	j	80000576 <mappages+0x34>
    panic("mappages: size");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ab250513          	addi	a0,a0,-1358 # 80008058 <etext+0x58>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	b44080e7          	jalr	-1212(ra) # 800060f2 <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ab250513          	addi	a0,a0,-1358 # 80008068 <etext+0x68>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	b34080e7          	jalr	-1228(ra) # 800060f2 <panic>
      return -1;
    800005c6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005c8:	60a6                	ld	ra,72(sp)
    800005ca:	6406                	ld	s0,64(sp)
    800005cc:	74e2                	ld	s1,56(sp)
    800005ce:	7942                	ld	s2,48(sp)
    800005d0:	79a2                	ld	s3,40(sp)
    800005d2:	7a02                	ld	s4,32(sp)
    800005d4:	6ae2                	ld	s5,24(sp)
    800005d6:	6b42                	ld	s6,16(sp)
    800005d8:	6ba2                	ld	s7,8(sp)
    800005da:	6161                	addi	sp,sp,80
    800005dc:	8082                	ret
  return 0;
    800005de:	4501                	li	a0,0
    800005e0:	b7e5                	j	800005c8 <mappages+0x86>

00000000800005e2 <kvmmap>:
{
    800005e2:	1141                	addi	sp,sp,-16
    800005e4:	e406                	sd	ra,8(sp)
    800005e6:	e022                	sd	s0,0(sp)
    800005e8:	0800                	addi	s0,sp,16
    800005ea:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ec:	86b2                	mv	a3,a2
    800005ee:	863e                	mv	a2,a5
    800005f0:	00000097          	auipc	ra,0x0
    800005f4:	f52080e7          	jalr	-174(ra) # 80000542 <mappages>
    800005f8:	e509                	bnez	a0,80000602 <kvmmap+0x20>
}
    800005fa:	60a2                	ld	ra,8(sp)
    800005fc:	6402                	ld	s0,0(sp)
    800005fe:	0141                	addi	sp,sp,16
    80000600:	8082                	ret
    panic("kvmmap");
    80000602:	00008517          	auipc	a0,0x8
    80000606:	a7650513          	addi	a0,a0,-1418 # 80008078 <etext+0x78>
    8000060a:	00006097          	auipc	ra,0x6
    8000060e:	ae8080e7          	jalr	-1304(ra) # 800060f2 <panic>

0000000080000612 <kvmmake>:
{
    80000612:	1101                	addi	sp,sp,-32
    80000614:	ec06                	sd	ra,24(sp)
    80000616:	e822                	sd	s0,16(sp)
    80000618:	e426                	sd	s1,8(sp)
    8000061a:	e04a                	sd	s2,0(sp)
    8000061c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	afc080e7          	jalr	-1284(ra) # 8000011a <kalloc>
    80000626:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000628:	6605                	lui	a2,0x1
    8000062a:	4581                	li	a1,0
    8000062c:	00000097          	auipc	ra,0x0
    80000630:	b4e080e7          	jalr	-1202(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000634:	4719                	li	a4,6
    80000636:	6685                	lui	a3,0x1
    80000638:	10000637          	lui	a2,0x10000
    8000063c:	100005b7          	lui	a1,0x10000
    80000640:	8526                	mv	a0,s1
    80000642:	00000097          	auipc	ra,0x0
    80000646:	fa0080e7          	jalr	-96(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064a:	4719                	li	a4,6
    8000064c:	6685                	lui	a3,0x1
    8000064e:	10001637          	lui	a2,0x10001
    80000652:	100015b7          	lui	a1,0x10001
    80000656:	8526                	mv	a0,s1
    80000658:	00000097          	auipc	ra,0x0
    8000065c:	f8a080e7          	jalr	-118(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000660:	4719                	li	a4,6
    80000662:	004006b7          	lui	a3,0x400
    80000666:	0c000637          	lui	a2,0xc000
    8000066a:	0c0005b7          	lui	a1,0xc000
    8000066e:	8526                	mv	a0,s1
    80000670:	00000097          	auipc	ra,0x0
    80000674:	f72080e7          	jalr	-142(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000678:	00008917          	auipc	s2,0x8
    8000067c:	98890913          	addi	s2,s2,-1656 # 80008000 <etext>
    80000680:	4729                	li	a4,10
    80000682:	80008697          	auipc	a3,0x80008
    80000686:	97e68693          	addi	a3,a3,-1666 # 8000 <_entry-0x7fff8000>
    8000068a:	4605                	li	a2,1
    8000068c:	067e                	slli	a2,a2,0x1f
    8000068e:	85b2                	mv	a1,a2
    80000690:	8526                	mv	a0,s1
    80000692:	00000097          	auipc	ra,0x0
    80000696:	f50080e7          	jalr	-176(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069a:	4719                	li	a4,6
    8000069c:	46c5                	li	a3,17
    8000069e:	06ee                	slli	a3,a3,0x1b
    800006a0:	412686b3          	sub	a3,a3,s2
    800006a4:	864a                	mv	a2,s2
    800006a6:	85ca                	mv	a1,s2
    800006a8:	8526                	mv	a0,s1
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	f38080e7          	jalr	-200(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b2:	4729                	li	a4,10
    800006b4:	6685                	lui	a3,0x1
    800006b6:	00007617          	auipc	a2,0x7
    800006ba:	94a60613          	addi	a2,a2,-1718 # 80007000 <_trampoline>
    800006be:	040005b7          	lui	a1,0x4000
    800006c2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c4:	05b2                	slli	a1,a1,0xc
    800006c6:	8526                	mv	a0,s1
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	f1a080e7          	jalr	-230(ra) # 800005e2 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d0:	8526                	mv	a0,s1
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	600080e7          	jalr	1536(ra) # 80000cd2 <proc_mapstacks>
}
    800006da:	8526                	mv	a0,s1
    800006dc:	60e2                	ld	ra,24(sp)
    800006de:	6442                	ld	s0,16(sp)
    800006e0:	64a2                	ld	s1,8(sp)
    800006e2:	6902                	ld	s2,0(sp)
    800006e4:	6105                	addi	sp,sp,32
    800006e6:	8082                	ret

00000000800006e8 <kvminit>:
{
    800006e8:	1141                	addi	sp,sp,-16
    800006ea:	e406                	sd	ra,8(sp)
    800006ec:	e022                	sd	s0,0(sp)
    800006ee:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	f22080e7          	jalr	-222(ra) # 80000612 <kvmmake>
    800006f8:	00009797          	auipc	a5,0x9
    800006fc:	90a7b823          	sd	a0,-1776(a5) # 80009008 <kernel_pagetable>
}
    80000700:	60a2                	ld	ra,8(sp)
    80000702:	6402                	ld	s0,0(sp)
    80000704:	0141                	addi	sp,sp,16
    80000706:	8082                	ret

0000000080000708 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000708:	715d                	addi	sp,sp,-80
    8000070a:	e486                	sd	ra,72(sp)
    8000070c:	e0a2                	sd	s0,64(sp)
    8000070e:	fc26                	sd	s1,56(sp)
    80000710:	f84a                	sd	s2,48(sp)
    80000712:	f44e                	sd	s3,40(sp)
    80000714:	f052                	sd	s4,32(sp)
    80000716:	ec56                	sd	s5,24(sp)
    80000718:	e85a                	sd	s6,16(sp)
    8000071a:	e45e                	sd	s7,8(sp)
    8000071c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000071e:	03459793          	slli	a5,a1,0x34
    80000722:	e795                	bnez	a5,8000074e <uvmunmap+0x46>
    80000724:	8a2a                	mv	s4,a0
    80000726:	892e                	mv	s2,a1
    80000728:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072a:	0632                	slli	a2,a2,0xc
    8000072c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000730:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000732:	6b05                	lui	s6,0x1
    80000734:	0735e263          	bltu	a1,s3,80000798 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000738:	60a6                	ld	ra,72(sp)
    8000073a:	6406                	ld	s0,64(sp)
    8000073c:	74e2                	ld	s1,56(sp)
    8000073e:	7942                	ld	s2,48(sp)
    80000740:	79a2                	ld	s3,40(sp)
    80000742:	7a02                	ld	s4,32(sp)
    80000744:	6ae2                	ld	s5,24(sp)
    80000746:	6b42                	ld	s6,16(sp)
    80000748:	6ba2                	ld	s7,8(sp)
    8000074a:	6161                	addi	sp,sp,80
    8000074c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000074e:	00008517          	auipc	a0,0x8
    80000752:	93250513          	addi	a0,a0,-1742 # 80008080 <etext+0x80>
    80000756:	00006097          	auipc	ra,0x6
    8000075a:	99c080e7          	jalr	-1636(ra) # 800060f2 <panic>
      panic("uvmunmap: walk");
    8000075e:	00008517          	auipc	a0,0x8
    80000762:	93a50513          	addi	a0,a0,-1734 # 80008098 <etext+0x98>
    80000766:	00006097          	auipc	ra,0x6
    8000076a:	98c080e7          	jalr	-1652(ra) # 800060f2 <panic>
      panic("uvmunmap: not mapped");
    8000076e:	00008517          	auipc	a0,0x8
    80000772:	93a50513          	addi	a0,a0,-1734 # 800080a8 <etext+0xa8>
    80000776:	00006097          	auipc	ra,0x6
    8000077a:	97c080e7          	jalr	-1668(ra) # 800060f2 <panic>
      panic("uvmunmap: not a leaf");
    8000077e:	00008517          	auipc	a0,0x8
    80000782:	94250513          	addi	a0,a0,-1726 # 800080c0 <etext+0xc0>
    80000786:	00006097          	auipc	ra,0x6
    8000078a:	96c080e7          	jalr	-1684(ra) # 800060f2 <panic>
    *pte = 0;
    8000078e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000792:	995a                	add	s2,s2,s6
    80000794:	fb3972e3          	bgeu	s2,s3,80000738 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000798:	4601                	li	a2,0
    8000079a:	85ca                	mv	a1,s2
    8000079c:	8552                	mv	a0,s4
    8000079e:	00000097          	auipc	ra,0x0
    800007a2:	cbc080e7          	jalr	-836(ra) # 8000045a <walk>
    800007a6:	84aa                	mv	s1,a0
    800007a8:	d95d                	beqz	a0,8000075e <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007aa:	6108                	ld	a0,0(a0)
    800007ac:	00157793          	andi	a5,a0,1
    800007b0:	dfdd                	beqz	a5,8000076e <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b2:	3ff57793          	andi	a5,a0,1023
    800007b6:	fd7784e3          	beq	a5,s7,8000077e <uvmunmap+0x76>
    if(do_free){
    800007ba:	fc0a8ae3          	beqz	s5,8000078e <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007be:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c0:	0532                	slli	a0,a0,0xc
    800007c2:	00000097          	auipc	ra,0x0
    800007c6:	85a080e7          	jalr	-1958(ra) # 8000001c <kfree>
    800007ca:	b7d1                	j	8000078e <uvmunmap+0x86>

00000000800007cc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007cc:	1101                	addi	sp,sp,-32
    800007ce:	ec06                	sd	ra,24(sp)
    800007d0:	e822                	sd	s0,16(sp)
    800007d2:	e426                	sd	s1,8(sp)
    800007d4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d6:	00000097          	auipc	ra,0x0
    800007da:	944080e7          	jalr	-1724(ra) # 8000011a <kalloc>
    800007de:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e0:	c519                	beqz	a0,800007ee <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e2:	6605                	lui	a2,0x1
    800007e4:	4581                	li	a1,0
    800007e6:	00000097          	auipc	ra,0x0
    800007ea:	994080e7          	jalr	-1644(ra) # 8000017a <memset>
  return pagetable;
}
    800007ee:	8526                	mv	a0,s1
    800007f0:	60e2                	ld	ra,24(sp)
    800007f2:	6442                	ld	s0,16(sp)
    800007f4:	64a2                	ld	s1,8(sp)
    800007f6:	6105                	addi	sp,sp,32
    800007f8:	8082                	ret

00000000800007fa <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fa:	7179                	addi	sp,sp,-48
    800007fc:	f406                	sd	ra,40(sp)
    800007fe:	f022                	sd	s0,32(sp)
    80000800:	ec26                	sd	s1,24(sp)
    80000802:	e84a                	sd	s2,16(sp)
    80000804:	e44e                	sd	s3,8(sp)
    80000806:	e052                	sd	s4,0(sp)
    80000808:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080a:	6785                	lui	a5,0x1
    8000080c:	04f67863          	bgeu	a2,a5,8000085c <uvminit+0x62>
    80000810:	8a2a                	mv	s4,a0
    80000812:	89ae                	mv	s3,a1
    80000814:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	904080e7          	jalr	-1788(ra) # 8000011a <kalloc>
    8000081e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000820:	6605                	lui	a2,0x1
    80000822:	4581                	li	a1,0
    80000824:	00000097          	auipc	ra,0x0
    80000828:	956080e7          	jalr	-1706(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082c:	4779                	li	a4,30
    8000082e:	86ca                	mv	a3,s2
    80000830:	6605                	lui	a2,0x1
    80000832:	4581                	li	a1,0
    80000834:	8552                	mv	a0,s4
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	d0c080e7          	jalr	-756(ra) # 80000542 <mappages>
  memmove(mem, src, sz);
    8000083e:	8626                	mv	a2,s1
    80000840:	85ce                	mv	a1,s3
    80000842:	854a                	mv	a0,s2
    80000844:	00000097          	auipc	ra,0x0
    80000848:	992080e7          	jalr	-1646(ra) # 800001d6 <memmove>
}
    8000084c:	70a2                	ld	ra,40(sp)
    8000084e:	7402                	ld	s0,32(sp)
    80000850:	64e2                	ld	s1,24(sp)
    80000852:	6942                	ld	s2,16(sp)
    80000854:	69a2                	ld	s3,8(sp)
    80000856:	6a02                	ld	s4,0(sp)
    80000858:	6145                	addi	sp,sp,48
    8000085a:	8082                	ret
    panic("inituvm: more than a page");
    8000085c:	00008517          	auipc	a0,0x8
    80000860:	87c50513          	addi	a0,a0,-1924 # 800080d8 <etext+0xd8>
    80000864:	00006097          	auipc	ra,0x6
    80000868:	88e080e7          	jalr	-1906(ra) # 800060f2 <panic>

000000008000086c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086c:	1101                	addi	sp,sp,-32
    8000086e:	ec06                	sd	ra,24(sp)
    80000870:	e822                	sd	s0,16(sp)
    80000872:	e426                	sd	s1,8(sp)
    80000874:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000876:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000878:	00b67d63          	bgeu	a2,a1,80000892 <uvmdealloc+0x26>
    8000087c:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000087e:	6785                	lui	a5,0x1
    80000880:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000882:	00f60733          	add	a4,a2,a5
    80000886:	76fd                	lui	a3,0xfffff
    80000888:	8f75                	and	a4,a4,a3
    8000088a:	97ae                	add	a5,a5,a1
    8000088c:	8ff5                	and	a5,a5,a3
    8000088e:	00f76863          	bltu	a4,a5,8000089e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000892:	8526                	mv	a0,s1
    80000894:	60e2                	ld	ra,24(sp)
    80000896:	6442                	ld	s0,16(sp)
    80000898:	64a2                	ld	s1,8(sp)
    8000089a:	6105                	addi	sp,sp,32
    8000089c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000089e:	8f99                	sub	a5,a5,a4
    800008a0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a2:	4685                	li	a3,1
    800008a4:	0007861b          	sext.w	a2,a5
    800008a8:	85ba                	mv	a1,a4
    800008aa:	00000097          	auipc	ra,0x0
    800008ae:	e5e080e7          	jalr	-418(ra) # 80000708 <uvmunmap>
    800008b2:	b7c5                	j	80000892 <uvmdealloc+0x26>

00000000800008b4 <uvmalloc>:
  if(newsz < oldsz)
    800008b4:	0ab66163          	bltu	a2,a1,80000956 <uvmalloc+0xa2>
{
    800008b8:	7139                	addi	sp,sp,-64
    800008ba:	fc06                	sd	ra,56(sp)
    800008bc:	f822                	sd	s0,48(sp)
    800008be:	f426                	sd	s1,40(sp)
    800008c0:	f04a                	sd	s2,32(sp)
    800008c2:	ec4e                	sd	s3,24(sp)
    800008c4:	e852                	sd	s4,16(sp)
    800008c6:	e456                	sd	s5,8(sp)
    800008c8:	0080                	addi	s0,sp,64
    800008ca:	8aaa                	mv	s5,a0
    800008cc:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008ce:	6785                	lui	a5,0x1
    800008d0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d2:	95be                	add	a1,a1,a5
    800008d4:	77fd                	lui	a5,0xfffff
    800008d6:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008da:	08c9f063          	bgeu	s3,a2,8000095a <uvmalloc+0xa6>
    800008de:	894e                	mv	s2,s3
    mem = kalloc();
    800008e0:	00000097          	auipc	ra,0x0
    800008e4:	83a080e7          	jalr	-1990(ra) # 8000011a <kalloc>
    800008e8:	84aa                	mv	s1,a0
    if(mem == 0){
    800008ea:	c51d                	beqz	a0,80000918 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008ec:	6605                	lui	a2,0x1
    800008ee:	4581                	li	a1,0
    800008f0:	00000097          	auipc	ra,0x0
    800008f4:	88a080e7          	jalr	-1910(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008f8:	4779                	li	a4,30
    800008fa:	86a6                	mv	a3,s1
    800008fc:	6605                	lui	a2,0x1
    800008fe:	85ca                	mv	a1,s2
    80000900:	8556                	mv	a0,s5
    80000902:	00000097          	auipc	ra,0x0
    80000906:	c40080e7          	jalr	-960(ra) # 80000542 <mappages>
    8000090a:	e905                	bnez	a0,8000093a <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090c:	6785                	lui	a5,0x1
    8000090e:	993e                	add	s2,s2,a5
    80000910:	fd4968e3          	bltu	s2,s4,800008e0 <uvmalloc+0x2c>
  return newsz;
    80000914:	8552                	mv	a0,s4
    80000916:	a809                	j	80000928 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000918:	864e                	mv	a2,s3
    8000091a:	85ca                	mv	a1,s2
    8000091c:	8556                	mv	a0,s5
    8000091e:	00000097          	auipc	ra,0x0
    80000922:	f4e080e7          	jalr	-178(ra) # 8000086c <uvmdealloc>
      return 0;
    80000926:	4501                	li	a0,0
}
    80000928:	70e2                	ld	ra,56(sp)
    8000092a:	7442                	ld	s0,48(sp)
    8000092c:	74a2                	ld	s1,40(sp)
    8000092e:	7902                	ld	s2,32(sp)
    80000930:	69e2                	ld	s3,24(sp)
    80000932:	6a42                	ld	s4,16(sp)
    80000934:	6aa2                	ld	s5,8(sp)
    80000936:	6121                	addi	sp,sp,64
    80000938:	8082                	ret
      kfree(mem);
    8000093a:	8526                	mv	a0,s1
    8000093c:	fffff097          	auipc	ra,0xfffff
    80000940:	6e0080e7          	jalr	1760(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000944:	864e                	mv	a2,s3
    80000946:	85ca                	mv	a1,s2
    80000948:	8556                	mv	a0,s5
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	f22080e7          	jalr	-222(ra) # 8000086c <uvmdealloc>
      return 0;
    80000952:	4501                	li	a0,0
    80000954:	bfd1                	j	80000928 <uvmalloc+0x74>
    return oldsz;
    80000956:	852e                	mv	a0,a1
}
    80000958:	8082                	ret
  return newsz;
    8000095a:	8532                	mv	a0,a2
    8000095c:	b7f1                	j	80000928 <uvmalloc+0x74>

000000008000095e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000095e:	7179                	addi	sp,sp,-48
    80000960:	f406                	sd	ra,40(sp)
    80000962:	f022                	sd	s0,32(sp)
    80000964:	ec26                	sd	s1,24(sp)
    80000966:	e84a                	sd	s2,16(sp)
    80000968:	e44e                	sd	s3,8(sp)
    8000096a:	e052                	sd	s4,0(sp)
    8000096c:	1800                	addi	s0,sp,48
    8000096e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000970:	84aa                	mv	s1,a0
    80000972:	6905                	lui	s2,0x1
    80000974:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000976:	4985                	li	s3,1
    80000978:	a829                	j	80000992 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000097a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000097c:	00c79513          	slli	a0,a5,0xc
    80000980:	00000097          	auipc	ra,0x0
    80000984:	fde080e7          	jalr	-34(ra) # 8000095e <freewalk>
      pagetable[i] = 0;
    80000988:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000098c:	04a1                	addi	s1,s1,8
    8000098e:	03248163          	beq	s1,s2,800009b0 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000992:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000994:	00f7f713          	andi	a4,a5,15
    80000998:	ff3701e3          	beq	a4,s3,8000097a <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000099c:	8b85                	andi	a5,a5,1
    8000099e:	d7fd                	beqz	a5,8000098c <freewalk+0x2e>
      panic("freewalk: leaf");
    800009a0:	00007517          	auipc	a0,0x7
    800009a4:	75850513          	addi	a0,a0,1880 # 800080f8 <etext+0xf8>
    800009a8:	00005097          	auipc	ra,0x5
    800009ac:	74a080e7          	jalr	1866(ra) # 800060f2 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b0:	8552                	mv	a0,s4
    800009b2:	fffff097          	auipc	ra,0xfffff
    800009b6:	66a080e7          	jalr	1642(ra) # 8000001c <kfree>
}
    800009ba:	70a2                	ld	ra,40(sp)
    800009bc:	7402                	ld	s0,32(sp)
    800009be:	64e2                	ld	s1,24(sp)
    800009c0:	6942                	ld	s2,16(sp)
    800009c2:	69a2                	ld	s3,8(sp)
    800009c4:	6a02                	ld	s4,0(sp)
    800009c6:	6145                	addi	sp,sp,48
    800009c8:	8082                	ret

00000000800009ca <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ca:	1101                	addi	sp,sp,-32
    800009cc:	ec06                	sd	ra,24(sp)
    800009ce:	e822                	sd	s0,16(sp)
    800009d0:	e426                	sd	s1,8(sp)
    800009d2:	1000                	addi	s0,sp,32
    800009d4:	84aa                	mv	s1,a0
  if(sz > 0)
    800009d6:	e999                	bnez	a1,800009ec <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009d8:	8526                	mv	a0,s1
    800009da:	00000097          	auipc	ra,0x0
    800009de:	f84080e7          	jalr	-124(ra) # 8000095e <freewalk>
}
    800009e2:	60e2                	ld	ra,24(sp)
    800009e4:	6442                	ld	s0,16(sp)
    800009e6:	64a2                	ld	s1,8(sp)
    800009e8:	6105                	addi	sp,sp,32
    800009ea:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009ec:	6785                	lui	a5,0x1
    800009ee:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009f0:	95be                	add	a1,a1,a5
    800009f2:	4685                	li	a3,1
    800009f4:	00c5d613          	srli	a2,a1,0xc
    800009f8:	4581                	li	a1,0
    800009fa:	00000097          	auipc	ra,0x0
    800009fe:	d0e080e7          	jalr	-754(ra) # 80000708 <uvmunmap>
    80000a02:	bfd9                	j	800009d8 <uvmfree+0xe>

0000000080000a04 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a04:	c679                	beqz	a2,80000ad2 <uvmcopy+0xce>
{
    80000a06:	715d                	addi	sp,sp,-80
    80000a08:	e486                	sd	ra,72(sp)
    80000a0a:	e0a2                	sd	s0,64(sp)
    80000a0c:	fc26                	sd	s1,56(sp)
    80000a0e:	f84a                	sd	s2,48(sp)
    80000a10:	f44e                	sd	s3,40(sp)
    80000a12:	f052                	sd	s4,32(sp)
    80000a14:	ec56                	sd	s5,24(sp)
    80000a16:	e85a                	sd	s6,16(sp)
    80000a18:	e45e                	sd	s7,8(sp)
    80000a1a:	0880                	addi	s0,sp,80
    80000a1c:	8b2a                	mv	s6,a0
    80000a1e:	8aae                	mv	s5,a1
    80000a20:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a22:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a24:	4601                	li	a2,0
    80000a26:	85ce                	mv	a1,s3
    80000a28:	855a                	mv	a0,s6
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	a30080e7          	jalr	-1488(ra) # 8000045a <walk>
    80000a32:	c531                	beqz	a0,80000a7e <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a34:	6118                	ld	a4,0(a0)
    80000a36:	00177793          	andi	a5,a4,1
    80000a3a:	cbb1                	beqz	a5,80000a8e <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a3c:	00a75593          	srli	a1,a4,0xa
    80000a40:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a44:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a48:	fffff097          	auipc	ra,0xfffff
    80000a4c:	6d2080e7          	jalr	1746(ra) # 8000011a <kalloc>
    80000a50:	892a                	mv	s2,a0
    80000a52:	c939                	beqz	a0,80000aa8 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a54:	6605                	lui	a2,0x1
    80000a56:	85de                	mv	a1,s7
    80000a58:	fffff097          	auipc	ra,0xfffff
    80000a5c:	77e080e7          	jalr	1918(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a60:	8726                	mv	a4,s1
    80000a62:	86ca                	mv	a3,s2
    80000a64:	6605                	lui	a2,0x1
    80000a66:	85ce                	mv	a1,s3
    80000a68:	8556                	mv	a0,s5
    80000a6a:	00000097          	auipc	ra,0x0
    80000a6e:	ad8080e7          	jalr	-1320(ra) # 80000542 <mappages>
    80000a72:	e515                	bnez	a0,80000a9e <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a74:	6785                	lui	a5,0x1
    80000a76:	99be                	add	s3,s3,a5
    80000a78:	fb49e6e3          	bltu	s3,s4,80000a24 <uvmcopy+0x20>
    80000a7c:	a081                	j	80000abc <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a7e:	00007517          	auipc	a0,0x7
    80000a82:	68a50513          	addi	a0,a0,1674 # 80008108 <etext+0x108>
    80000a86:	00005097          	auipc	ra,0x5
    80000a8a:	66c080e7          	jalr	1644(ra) # 800060f2 <panic>
      panic("uvmcopy: page not present");
    80000a8e:	00007517          	auipc	a0,0x7
    80000a92:	69a50513          	addi	a0,a0,1690 # 80008128 <etext+0x128>
    80000a96:	00005097          	auipc	ra,0x5
    80000a9a:	65c080e7          	jalr	1628(ra) # 800060f2 <panic>
      kfree(mem);
    80000a9e:	854a                	mv	a0,s2
    80000aa0:	fffff097          	auipc	ra,0xfffff
    80000aa4:	57c080e7          	jalr	1404(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aa8:	4685                	li	a3,1
    80000aaa:	00c9d613          	srli	a2,s3,0xc
    80000aae:	4581                	li	a1,0
    80000ab0:	8556                	mv	a0,s5
    80000ab2:	00000097          	auipc	ra,0x0
    80000ab6:	c56080e7          	jalr	-938(ra) # 80000708 <uvmunmap>
  return -1;
    80000aba:	557d                	li	a0,-1
}
    80000abc:	60a6                	ld	ra,72(sp)
    80000abe:	6406                	ld	s0,64(sp)
    80000ac0:	74e2                	ld	s1,56(sp)
    80000ac2:	7942                	ld	s2,48(sp)
    80000ac4:	79a2                	ld	s3,40(sp)
    80000ac6:	7a02                	ld	s4,32(sp)
    80000ac8:	6ae2                	ld	s5,24(sp)
    80000aca:	6b42                	ld	s6,16(sp)
    80000acc:	6ba2                	ld	s7,8(sp)
    80000ace:	6161                	addi	sp,sp,80
    80000ad0:	8082                	ret
  return 0;
    80000ad2:	4501                	li	a0,0
}
    80000ad4:	8082                	ret

0000000080000ad6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad6:	1141                	addi	sp,sp,-16
    80000ad8:	e406                	sd	ra,8(sp)
    80000ada:	e022                	sd	s0,0(sp)
    80000adc:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ade:	4601                	li	a2,0
    80000ae0:	00000097          	auipc	ra,0x0
    80000ae4:	97a080e7          	jalr	-1670(ra) # 8000045a <walk>
  if(pte == 0)
    80000ae8:	c901                	beqz	a0,80000af8 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aea:	611c                	ld	a5,0(a0)
    80000aec:	9bbd                	andi	a5,a5,-17
    80000aee:	e11c                	sd	a5,0(a0)
}
    80000af0:	60a2                	ld	ra,8(sp)
    80000af2:	6402                	ld	s0,0(sp)
    80000af4:	0141                	addi	sp,sp,16
    80000af6:	8082                	ret
    panic("uvmclear");
    80000af8:	00007517          	auipc	a0,0x7
    80000afc:	65050513          	addi	a0,a0,1616 # 80008148 <etext+0x148>
    80000b00:	00005097          	auipc	ra,0x5
    80000b04:	5f2080e7          	jalr	1522(ra) # 800060f2 <panic>

0000000080000b08 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b08:	c6bd                	beqz	a3,80000b76 <copyout+0x6e>
{
    80000b0a:	715d                	addi	sp,sp,-80
    80000b0c:	e486                	sd	ra,72(sp)
    80000b0e:	e0a2                	sd	s0,64(sp)
    80000b10:	fc26                	sd	s1,56(sp)
    80000b12:	f84a                	sd	s2,48(sp)
    80000b14:	f44e                	sd	s3,40(sp)
    80000b16:	f052                	sd	s4,32(sp)
    80000b18:	ec56                	sd	s5,24(sp)
    80000b1a:	e85a                	sd	s6,16(sp)
    80000b1c:	e45e                	sd	s7,8(sp)
    80000b1e:	e062                	sd	s8,0(sp)
    80000b20:	0880                	addi	s0,sp,80
    80000b22:	8b2a                	mv	s6,a0
    80000b24:	8c2e                	mv	s8,a1
    80000b26:	8a32                	mv	s4,a2
    80000b28:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2c:	6a85                	lui	s5,0x1
    80000b2e:	a015                	j	80000b52 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b30:	9562                	add	a0,a0,s8
    80000b32:	0004861b          	sext.w	a2,s1
    80000b36:	85d2                	mv	a1,s4
    80000b38:	41250533          	sub	a0,a0,s2
    80000b3c:	fffff097          	auipc	ra,0xfffff
    80000b40:	69a080e7          	jalr	1690(ra) # 800001d6 <memmove>

    len -= n;
    80000b44:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b48:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b4a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b4e:	02098263          	beqz	s3,80000b72 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b52:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b56:	85ca                	mv	a1,s2
    80000b58:	855a                	mv	a0,s6
    80000b5a:	00000097          	auipc	ra,0x0
    80000b5e:	9a6080e7          	jalr	-1626(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000b62:	cd01                	beqz	a0,80000b7a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b64:	418904b3          	sub	s1,s2,s8
    80000b68:	94d6                	add	s1,s1,s5
    80000b6a:	fc99f3e3          	bgeu	s3,s1,80000b30 <copyout+0x28>
    80000b6e:	84ce                	mv	s1,s3
    80000b70:	b7c1                	j	80000b30 <copyout+0x28>
  }
  return 0;
    80000b72:	4501                	li	a0,0
    80000b74:	a021                	j	80000b7c <copyout+0x74>
    80000b76:	4501                	li	a0,0
}
    80000b78:	8082                	ret
      return -1;
    80000b7a:	557d                	li	a0,-1
}
    80000b7c:	60a6                	ld	ra,72(sp)
    80000b7e:	6406                	ld	s0,64(sp)
    80000b80:	74e2                	ld	s1,56(sp)
    80000b82:	7942                	ld	s2,48(sp)
    80000b84:	79a2                	ld	s3,40(sp)
    80000b86:	7a02                	ld	s4,32(sp)
    80000b88:	6ae2                	ld	s5,24(sp)
    80000b8a:	6b42                	ld	s6,16(sp)
    80000b8c:	6ba2                	ld	s7,8(sp)
    80000b8e:	6c02                	ld	s8,0(sp)
    80000b90:	6161                	addi	sp,sp,80
    80000b92:	8082                	ret

0000000080000b94 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b94:	caa5                	beqz	a3,80000c04 <copyin+0x70>
{
    80000b96:	715d                	addi	sp,sp,-80
    80000b98:	e486                	sd	ra,72(sp)
    80000b9a:	e0a2                	sd	s0,64(sp)
    80000b9c:	fc26                	sd	s1,56(sp)
    80000b9e:	f84a                	sd	s2,48(sp)
    80000ba0:	f44e                	sd	s3,40(sp)
    80000ba2:	f052                	sd	s4,32(sp)
    80000ba4:	ec56                	sd	s5,24(sp)
    80000ba6:	e85a                	sd	s6,16(sp)
    80000ba8:	e45e                	sd	s7,8(sp)
    80000baa:	e062                	sd	s8,0(sp)
    80000bac:	0880                	addi	s0,sp,80
    80000bae:	8b2a                	mv	s6,a0
    80000bb0:	8a2e                	mv	s4,a1
    80000bb2:	8c32                	mv	s8,a2
    80000bb4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bb8:	6a85                	lui	s5,0x1
    80000bba:	a01d                	j	80000be0 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bbc:	018505b3          	add	a1,a0,s8
    80000bc0:	0004861b          	sext.w	a2,s1
    80000bc4:	412585b3          	sub	a1,a1,s2
    80000bc8:	8552                	mv	a0,s4
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	60c080e7          	jalr	1548(ra) # 800001d6 <memmove>

    len -= n;
    80000bd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bdc:	02098263          	beqz	s3,80000c00 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000be0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85ca                	mv	a1,s2
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	918080e7          	jalr	-1768(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000bf0:	cd01                	beqz	a0,80000c08 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bf2:	418904b3          	sub	s1,s2,s8
    80000bf6:	94d6                	add	s1,s1,s5
    80000bf8:	fc99f2e3          	bgeu	s3,s1,80000bbc <copyin+0x28>
    80000bfc:	84ce                	mv	s1,s3
    80000bfe:	bf7d                	j	80000bbc <copyin+0x28>
  }
  return 0;
    80000c00:	4501                	li	a0,0
    80000c02:	a021                	j	80000c0a <copyin+0x76>
    80000c04:	4501                	li	a0,0
}
    80000c06:	8082                	ret
      return -1;
    80000c08:	557d                	li	a0,-1
}
    80000c0a:	60a6                	ld	ra,72(sp)
    80000c0c:	6406                	ld	s0,64(sp)
    80000c0e:	74e2                	ld	s1,56(sp)
    80000c10:	7942                	ld	s2,48(sp)
    80000c12:	79a2                	ld	s3,40(sp)
    80000c14:	7a02                	ld	s4,32(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	6c02                	ld	s8,0(sp)
    80000c1e:	6161                	addi	sp,sp,80
    80000c20:	8082                	ret

0000000080000c22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c22:	c2dd                	beqz	a3,80000cc8 <copyinstr+0xa6>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8a2a                	mv	s4,a0
    80000c3c:	8b2e                	mv	s6,a1
    80000c3e:	8bb2                	mv	s7,a2
    80000c40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6985                	lui	s3,0x1
    80000c46:	a02d                	j	80000c70 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4e:	37fd                	addiw	a5,a5,-1
    80000c50:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c54:	60a6                	ld	ra,72(sp)
    80000c56:	6406                	ld	s0,64(sp)
    80000c58:	74e2                	ld	s1,56(sp)
    80000c5a:	7942                	ld	s2,48(sp)
    80000c5c:	79a2                	ld	s3,40(sp)
    80000c5e:	7a02                	ld	s4,32(sp)
    80000c60:	6ae2                	ld	s5,24(sp)
    80000c62:	6b42                	ld	s6,16(sp)
    80000c64:	6ba2                	ld	s7,8(sp)
    80000c66:	6161                	addi	sp,sp,80
    80000c68:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c6a:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c6e:	c8a9                	beqz	s1,80000cc0 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c70:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c74:	85ca                	mv	a1,s2
    80000c76:	8552                	mv	a0,s4
    80000c78:	00000097          	auipc	ra,0x0
    80000c7c:	888080e7          	jalr	-1912(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000c80:	c131                	beqz	a0,80000cc4 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c82:	417906b3          	sub	a3,s2,s7
    80000c86:	96ce                	add	a3,a3,s3
    80000c88:	00d4f363          	bgeu	s1,a3,80000c8e <copyinstr+0x6c>
    80000c8c:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c8e:	955e                	add	a0,a0,s7
    80000c90:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c94:	daf9                	beqz	a3,80000c6a <copyinstr+0x48>
    80000c96:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c98:	41650633          	sub	a2,a0,s6
    80000c9c:	fff48593          	addi	a1,s1,-1
    80000ca0:	95da                	add	a1,a1,s6
    while(n > 0){
    80000ca2:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000ca4:	00f60733          	add	a4,a2,a5
    80000ca8:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffccdc0>
    80000cac:	df51                	beqz	a4,80000c48 <copyinstr+0x26>
        *dst = *p;
    80000cae:	00e78023          	sb	a4,0(a5)
      --max;
    80000cb2:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000cb6:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cb8:	fed796e3          	bne	a5,a3,80000ca4 <copyinstr+0x82>
      dst++;
    80000cbc:	8b3e                	mv	s6,a5
    80000cbe:	b775                	j	80000c6a <copyinstr+0x48>
    80000cc0:	4781                	li	a5,0
    80000cc2:	b771                	j	80000c4e <copyinstr+0x2c>
      return -1;
    80000cc4:	557d                	li	a0,-1
    80000cc6:	b779                	j	80000c54 <copyinstr+0x32>
  int got_null = 0;
    80000cc8:	4781                	li	a5,0
  if(got_null){
    80000cca:	37fd                	addiw	a5,a5,-1
    80000ccc:	0007851b          	sext.w	a0,a5
}
    80000cd0:	8082                	ret

0000000080000cd2 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd2:	7139                	addi	sp,sp,-64
    80000cd4:	fc06                	sd	ra,56(sp)
    80000cd6:	f822                	sd	s0,48(sp)
    80000cd8:	f426                	sd	s1,40(sp)
    80000cda:	f04a                	sd	s2,32(sp)
    80000cdc:	ec4e                	sd	s3,24(sp)
    80000cde:	e852                	sd	s4,16(sp)
    80000ce0:	e456                	sd	s5,8(sp)
    80000ce2:	e05a                	sd	s6,0(sp)
    80000ce4:	0080                	addi	s0,sp,64
    80000ce6:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce8:	00008497          	auipc	s1,0x8
    80000cec:	79848493          	addi	s1,s1,1944 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf0:	8b26                	mv	s6,s1
    80000cf2:	00007a97          	auipc	s5,0x7
    80000cf6:	30ea8a93          	addi	s5,s5,782 # 80008000 <etext>
    80000cfa:	04000937          	lui	s2,0x4000
    80000cfe:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d00:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d02:	0001aa17          	auipc	s4,0x1a
    80000d06:	37ea0a13          	addi	s4,s4,894 # 8001b080 <tickslock>
    char *pa = kalloc();
    80000d0a:	fffff097          	auipc	ra,0xfffff
    80000d0e:	410080e7          	jalr	1040(ra) # 8000011a <kalloc>
    80000d12:	862a                	mv	a2,a0
    if(pa == 0)
    80000d14:	c131                	beqz	a0,80000d58 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d16:	416485b3          	sub	a1,s1,s6
    80000d1a:	8591                	srai	a1,a1,0x4
    80000d1c:	000ab783          	ld	a5,0(s5)
    80000d20:	02f585b3          	mul	a1,a1,a5
    80000d24:	2585                	addiw	a1,a1,1
    80000d26:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d2a:	4719                	li	a4,6
    80000d2c:	6685                	lui	a3,0x1
    80000d2e:	40b905b3          	sub	a1,s2,a1
    80000d32:	854e                	mv	a0,s3
    80000d34:	00000097          	auipc	ra,0x0
    80000d38:	8ae080e7          	jalr	-1874(ra) # 800005e2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d3c:	47048493          	addi	s1,s1,1136
    80000d40:	fd4495e3          	bne	s1,s4,80000d0a <proc_mapstacks+0x38>
  }
}
    80000d44:	70e2                	ld	ra,56(sp)
    80000d46:	7442                	ld	s0,48(sp)
    80000d48:	74a2                	ld	s1,40(sp)
    80000d4a:	7902                	ld	s2,32(sp)
    80000d4c:	69e2                	ld	s3,24(sp)
    80000d4e:	6a42                	ld	s4,16(sp)
    80000d50:	6aa2                	ld	s5,8(sp)
    80000d52:	6b02                	ld	s6,0(sp)
    80000d54:	6121                	addi	sp,sp,64
    80000d56:	8082                	ret
      panic("kalloc");
    80000d58:	00007517          	auipc	a0,0x7
    80000d5c:	40050513          	addi	a0,a0,1024 # 80008158 <etext+0x158>
    80000d60:	00005097          	auipc	ra,0x5
    80000d64:	392080e7          	jalr	914(ra) # 800060f2 <panic>

0000000080000d68 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d68:	7139                	addi	sp,sp,-64
    80000d6a:	fc06                	sd	ra,56(sp)
    80000d6c:	f822                	sd	s0,48(sp)
    80000d6e:	f426                	sd	s1,40(sp)
    80000d70:	f04a                	sd	s2,32(sp)
    80000d72:	ec4e                	sd	s3,24(sp)
    80000d74:	e852                	sd	s4,16(sp)
    80000d76:	e456                	sd	s5,8(sp)
    80000d78:	e05a                	sd	s6,0(sp)
    80000d7a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d7c:	00007597          	auipc	a1,0x7
    80000d80:	3e458593          	addi	a1,a1,996 # 80008160 <etext+0x160>
    80000d84:	00008517          	auipc	a0,0x8
    80000d88:	2cc50513          	addi	a0,a0,716 # 80009050 <pid_lock>
    80000d8c:	00006097          	auipc	ra,0x6
    80000d90:	80e080e7          	jalr	-2034(ra) # 8000659a <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d94:	00007597          	auipc	a1,0x7
    80000d98:	3d458593          	addi	a1,a1,980 # 80008168 <etext+0x168>
    80000d9c:	00008517          	auipc	a0,0x8
    80000da0:	2cc50513          	addi	a0,a0,716 # 80009068 <wait_lock>
    80000da4:	00005097          	auipc	ra,0x5
    80000da8:	7f6080e7          	jalr	2038(ra) # 8000659a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dac:	00008497          	auipc	s1,0x8
    80000db0:	6d448493          	addi	s1,s1,1748 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db4:	00007b17          	auipc	s6,0x7
    80000db8:	3c4b0b13          	addi	s6,s6,964 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dbc:	8aa6                	mv	s5,s1
    80000dbe:	00007a17          	auipc	s4,0x7
    80000dc2:	242a0a13          	addi	s4,s4,578 # 80008000 <etext>
    80000dc6:	04000937          	lui	s2,0x4000
    80000dca:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000dcc:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dce:	0001a997          	auipc	s3,0x1a
    80000dd2:	2b298993          	addi	s3,s3,690 # 8001b080 <tickslock>
      initlock(&p->lock, "proc");
    80000dd6:	85da                	mv	a1,s6
    80000dd8:	8526                	mv	a0,s1
    80000dda:	00005097          	auipc	ra,0x5
    80000dde:	7c0080e7          	jalr	1984(ra) # 8000659a <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de2:	415487b3          	sub	a5,s1,s5
    80000de6:	8791                	srai	a5,a5,0x4
    80000de8:	000a3703          	ld	a4,0(s4)
    80000dec:	02e787b3          	mul	a5,a5,a4
    80000df0:	2785                	addiw	a5,a5,1
    80000df2:	00d7979b          	slliw	a5,a5,0xd
    80000df6:	40f907b3          	sub	a5,s2,a5
    80000dfa:	34f4b423          	sd	a5,840(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfe:	47048493          	addi	s1,s1,1136
    80000e02:	fd349ae3          	bne	s1,s3,80000dd6 <procinit+0x6e>
  }
}
    80000e06:	70e2                	ld	ra,56(sp)
    80000e08:	7442                	ld	s0,48(sp)
    80000e0a:	74a2                	ld	s1,40(sp)
    80000e0c:	7902                	ld	s2,32(sp)
    80000e0e:	69e2                	ld	s3,24(sp)
    80000e10:	6a42                	ld	s4,16(sp)
    80000e12:	6aa2                	ld	s5,8(sp)
    80000e14:	6b02                	ld	s6,0(sp)
    80000e16:	6121                	addi	sp,sp,64
    80000e18:	8082                	ret

0000000080000e1a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e1a:	1141                	addi	sp,sp,-16
    80000e1c:	e422                	sd	s0,8(sp)
    80000e1e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e20:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e22:	2501                	sext.w	a0,a0
    80000e24:	6422                	ld	s0,8(sp)
    80000e26:	0141                	addi	sp,sp,16
    80000e28:	8082                	ret

0000000080000e2a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e2a:	1141                	addi	sp,sp,-16
    80000e2c:	e422                	sd	s0,8(sp)
    80000e2e:	0800                	addi	s0,sp,16
    80000e30:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e32:	2781                	sext.w	a5,a5
    80000e34:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e36:	00008517          	auipc	a0,0x8
    80000e3a:	24a50513          	addi	a0,a0,586 # 80009080 <cpus>
    80000e3e:	953e                	add	a0,a0,a5
    80000e40:	6422                	ld	s0,8(sp)
    80000e42:	0141                	addi	sp,sp,16
    80000e44:	8082                	ret

0000000080000e46 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e46:	1101                	addi	sp,sp,-32
    80000e48:	ec06                	sd	ra,24(sp)
    80000e4a:	e822                	sd	s0,16(sp)
    80000e4c:	e426                	sd	s1,8(sp)
    80000e4e:	1000                	addi	s0,sp,32
  push_off();
    80000e50:	00005097          	auipc	ra,0x5
    80000e54:	78e080e7          	jalr	1934(ra) # 800065de <push_off>
    80000e58:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e5a:	2781                	sext.w	a5,a5
    80000e5c:	079e                	slli	a5,a5,0x7
    80000e5e:	00008717          	auipc	a4,0x8
    80000e62:	1f270713          	addi	a4,a4,498 # 80009050 <pid_lock>
    80000e66:	97ba                	add	a5,a5,a4
    80000e68:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e6a:	00006097          	auipc	ra,0x6
    80000e6e:	814080e7          	jalr	-2028(ra) # 8000667e <pop_off>
  return p;
}
    80000e72:	8526                	mv	a0,s1
    80000e74:	60e2                	ld	ra,24(sp)
    80000e76:	6442                	ld	s0,16(sp)
    80000e78:	64a2                	ld	s1,8(sp)
    80000e7a:	6105                	addi	sp,sp,32
    80000e7c:	8082                	ret

0000000080000e7e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e7e:	1141                	addi	sp,sp,-16
    80000e80:	e406                	sd	ra,8(sp)
    80000e82:	e022                	sd	s0,0(sp)
    80000e84:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e86:	00000097          	auipc	ra,0x0
    80000e8a:	fc0080e7          	jalr	-64(ra) # 80000e46 <myproc>
    80000e8e:	00006097          	auipc	ra,0x6
    80000e92:	850080e7          	jalr	-1968(ra) # 800066de <release>

  if (first) {
    80000e96:	00008797          	auipc	a5,0x8
    80000e9a:	9ea7a783          	lw	a5,-1558(a5) # 80008880 <first.1>
    80000e9e:	eb89                	bnez	a5,80000eb0 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ea0:	00001097          	auipc	ra,0x1
    80000ea4:	d5e080e7          	jalr	-674(ra) # 80001bfe <usertrapret>
}
    80000ea8:	60a2                	ld	ra,8(sp)
    80000eaa:	6402                	ld	s0,0(sp)
    80000eac:	0141                	addi	sp,sp,16
    80000eae:	8082                	ret
    first = 0;
    80000eb0:	00008797          	auipc	a5,0x8
    80000eb4:	9c07a823          	sw	zero,-1584(a5) # 80008880 <first.1>
    fsinit(ROOTDEV);
    80000eb8:	4505                	li	a0,1
    80000eba:	00002097          	auipc	ra,0x2
    80000ebe:	bba080e7          	jalr	-1094(ra) # 80002a74 <fsinit>
    80000ec2:	bff9                	j	80000ea0 <forkret+0x22>

0000000080000ec4 <allocpid>:
allocpid() {
    80000ec4:	1101                	addi	sp,sp,-32
    80000ec6:	ec06                	sd	ra,24(sp)
    80000ec8:	e822                	sd	s0,16(sp)
    80000eca:	e426                	sd	s1,8(sp)
    80000ecc:	e04a                	sd	s2,0(sp)
    80000ece:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ed0:	00008917          	auipc	s2,0x8
    80000ed4:	18090913          	addi	s2,s2,384 # 80009050 <pid_lock>
    80000ed8:	854a                	mv	a0,s2
    80000eda:	00005097          	auipc	ra,0x5
    80000ede:	750080e7          	jalr	1872(ra) # 8000662a <acquire>
  pid = nextpid;
    80000ee2:	00008797          	auipc	a5,0x8
    80000ee6:	9a278793          	addi	a5,a5,-1630 # 80008884 <nextpid>
    80000eea:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eec:	0014871b          	addiw	a4,s1,1
    80000ef0:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef2:	854a                	mv	a0,s2
    80000ef4:	00005097          	auipc	ra,0x5
    80000ef8:	7ea080e7          	jalr	2026(ra) # 800066de <release>
}
    80000efc:	8526                	mv	a0,s1
    80000efe:	60e2                	ld	ra,24(sp)
    80000f00:	6442                	ld	s0,16(sp)
    80000f02:	64a2                	ld	s1,8(sp)
    80000f04:	6902                	ld	s2,0(sp)
    80000f06:	6105                	addi	sp,sp,32
    80000f08:	8082                	ret

0000000080000f0a <proc_pagetable>:
{
    80000f0a:	1101                	addi	sp,sp,-32
    80000f0c:	ec06                	sd	ra,24(sp)
    80000f0e:	e822                	sd	s0,16(sp)
    80000f10:	e426                	sd	s1,8(sp)
    80000f12:	e04a                	sd	s2,0(sp)
    80000f14:	1000                	addi	s0,sp,32
    80000f16:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f18:	00000097          	auipc	ra,0x0
    80000f1c:	8b4080e7          	jalr	-1868(ra) # 800007cc <uvmcreate>
    80000f20:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f22:	c121                	beqz	a0,80000f62 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f24:	4729                	li	a4,10
    80000f26:	00006697          	auipc	a3,0x6
    80000f2a:	0da68693          	addi	a3,a3,218 # 80007000 <_trampoline>
    80000f2e:	6605                	lui	a2,0x1
    80000f30:	040005b7          	lui	a1,0x4000
    80000f34:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f36:	05b2                	slli	a1,a1,0xc
    80000f38:	fffff097          	auipc	ra,0xfffff
    80000f3c:	60a080e7          	jalr	1546(ra) # 80000542 <mappages>
    80000f40:	02054863          	bltz	a0,80000f70 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f44:	4719                	li	a4,6
    80000f46:	36093683          	ld	a3,864(s2)
    80000f4a:	6605                	lui	a2,0x1
    80000f4c:	020005b7          	lui	a1,0x2000
    80000f50:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f52:	05b6                	slli	a1,a1,0xd
    80000f54:	8526                	mv	a0,s1
    80000f56:	fffff097          	auipc	ra,0xfffff
    80000f5a:	5ec080e7          	jalr	1516(ra) # 80000542 <mappages>
    80000f5e:	02054163          	bltz	a0,80000f80 <proc_pagetable+0x76>
}
    80000f62:	8526                	mv	a0,s1
    80000f64:	60e2                	ld	ra,24(sp)
    80000f66:	6442                	ld	s0,16(sp)
    80000f68:	64a2                	ld	s1,8(sp)
    80000f6a:	6902                	ld	s2,0(sp)
    80000f6c:	6105                	addi	sp,sp,32
    80000f6e:	8082                	ret
    uvmfree(pagetable, 0);
    80000f70:	4581                	li	a1,0
    80000f72:	8526                	mv	a0,s1
    80000f74:	00000097          	auipc	ra,0x0
    80000f78:	a56080e7          	jalr	-1450(ra) # 800009ca <uvmfree>
    return 0;
    80000f7c:	4481                	li	s1,0
    80000f7e:	b7d5                	j	80000f62 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f80:	4681                	li	a3,0
    80000f82:	4605                	li	a2,1
    80000f84:	040005b7          	lui	a1,0x4000
    80000f88:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f8a:	05b2                	slli	a1,a1,0xc
    80000f8c:	8526                	mv	a0,s1
    80000f8e:	fffff097          	auipc	ra,0xfffff
    80000f92:	77a080e7          	jalr	1914(ra) # 80000708 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f96:	4581                	li	a1,0
    80000f98:	8526                	mv	a0,s1
    80000f9a:	00000097          	auipc	ra,0x0
    80000f9e:	a30080e7          	jalr	-1488(ra) # 800009ca <uvmfree>
    return 0;
    80000fa2:	4481                	li	s1,0
    80000fa4:	bf7d                	j	80000f62 <proc_pagetable+0x58>

0000000080000fa6 <proc_freepagetable>:
{
    80000fa6:	1101                	addi	sp,sp,-32
    80000fa8:	ec06                	sd	ra,24(sp)
    80000faa:	e822                	sd	s0,16(sp)
    80000fac:	e426                	sd	s1,8(sp)
    80000fae:	e04a                	sd	s2,0(sp)
    80000fb0:	1000                	addi	s0,sp,32
    80000fb2:	84aa                	mv	s1,a0
    80000fb4:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb6:	4681                	li	a3,0
    80000fb8:	4605                	li	a2,1
    80000fba:	040005b7          	lui	a1,0x4000
    80000fbe:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fc0:	05b2                	slli	a1,a1,0xc
    80000fc2:	fffff097          	auipc	ra,0xfffff
    80000fc6:	746080e7          	jalr	1862(ra) # 80000708 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fca:	4681                	li	a3,0
    80000fcc:	4605                	li	a2,1
    80000fce:	020005b7          	lui	a1,0x2000
    80000fd2:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fd4:	05b6                	slli	a1,a1,0xd
    80000fd6:	8526                	mv	a0,s1
    80000fd8:	fffff097          	auipc	ra,0xfffff
    80000fdc:	730080e7          	jalr	1840(ra) # 80000708 <uvmunmap>
  uvmfree(pagetable, sz);
    80000fe0:	85ca                	mv	a1,s2
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	00000097          	auipc	ra,0x0
    80000fe8:	9e6080e7          	jalr	-1562(ra) # 800009ca <uvmfree>
}
    80000fec:	60e2                	ld	ra,24(sp)
    80000fee:	6442                	ld	s0,16(sp)
    80000ff0:	64a2                	ld	s1,8(sp)
    80000ff2:	6902                	ld	s2,0(sp)
    80000ff4:	6105                	addi	sp,sp,32
    80000ff6:	8082                	ret

0000000080000ff8 <freeproc>:
{
    80000ff8:	1101                	addi	sp,sp,-32
    80000ffa:	ec06                	sd	ra,24(sp)
    80000ffc:	e822                	sd	s0,16(sp)
    80000ffe:	e426                	sd	s1,8(sp)
    80001000:	1000                	addi	s0,sp,32
    80001002:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001004:	36053503          	ld	a0,864(a0)
    80001008:	c509                	beqz	a0,80001012 <freeproc+0x1a>
    kfree((void*)p->trapframe);
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	012080e7          	jalr	18(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001012:	3604b023          	sd	zero,864(s1)
  if(p->pagetable)
    80001016:	3584b503          	ld	a0,856(s1)
    8000101a:	c519                	beqz	a0,80001028 <freeproc+0x30>
    proc_freepagetable(p->pagetable, p->sz);
    8000101c:	3504b583          	ld	a1,848(s1)
    80001020:	00000097          	auipc	ra,0x0
    80001024:	f86080e7          	jalr	-122(ra) # 80000fa6 <proc_freepagetable>
  p->pagetable = 0;
    80001028:	3404bc23          	sd	zero,856(s1)
  p->sz = 0;
    8000102c:	3404b823          	sd	zero,848(s1)
  p->pid = 0;
    80001030:	3204ac23          	sw	zero,824(s1)
  p->parent = 0;
    80001034:	3404b023          	sd	zero,832(s1)
  p->name[0] = 0;
    80001038:	46048023          	sb	zero,1120(s1)
  p->chan = 0;
    8000103c:	3204b423          	sd	zero,808(s1)
  p->killed = 0;
    80001040:	3204a823          	sw	zero,816(s1)
  p->xstate = 0;
    80001044:	3204aa23          	sw	zero,820(s1)
  p->state = UNUSED;
    80001048:	3204a023          	sw	zero,800(s1)
}
    8000104c:	60e2                	ld	ra,24(sp)
    8000104e:	6442                	ld	s0,16(sp)
    80001050:	64a2                	ld	s1,8(sp)
    80001052:	6105                	addi	sp,sp,32
    80001054:	8082                	ret

0000000080001056 <allocproc>:
{
    80001056:	7179                	addi	sp,sp,-48
    80001058:	f406                	sd	ra,40(sp)
    8000105a:	f022                	sd	s0,32(sp)
    8000105c:	ec26                	sd	s1,24(sp)
    8000105e:	e84a                	sd	s2,16(sp)
    80001060:	e44e                	sd	s3,8(sp)
    80001062:	1800                	addi	s0,sp,48
  for(p = proc; p < &proc[NPROC]; p++) {
    80001064:	00008497          	auipc	s1,0x8
    80001068:	41c48493          	addi	s1,s1,1052 # 80009480 <proc>
    8000106c:	0001a997          	auipc	s3,0x1a
    80001070:	01498993          	addi	s3,s3,20 # 8001b080 <tickslock>
    acquire(&p->lock);
    80001074:	8526                	mv	a0,s1
    80001076:	00005097          	auipc	ra,0x5
    8000107a:	5b4080e7          	jalr	1460(ra) # 8000662a <acquire>
    if(p->state == UNUSED) {
    8000107e:	3204a783          	lw	a5,800(s1)
    80001082:	cf81                	beqz	a5,8000109a <allocproc+0x44>
      release(&p->lock);
    80001084:	8526                	mv	a0,s1
    80001086:	00005097          	auipc	ra,0x5
    8000108a:	658080e7          	jalr	1624(ra) # 800066de <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000108e:	47048493          	addi	s1,s1,1136
    80001092:	ff3491e3          	bne	s1,s3,80001074 <allocproc+0x1e>
  return 0;
    80001096:	4481                	li	s1,0
    80001098:	a051                	j	8000111c <allocproc+0xc6>
  p->pid = allocpid();
    8000109a:	00000097          	auipc	ra,0x0
    8000109e:	e2a080e7          	jalr	-470(ra) # 80000ec4 <allocpid>
    800010a2:	32a4ac23          	sw	a0,824(s1)
  p->state = USED;
    800010a6:	4785                	li	a5,1
    800010a8:	32f4a023          	sw	a5,800(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010ac:	fffff097          	auipc	ra,0xfffff
    800010b0:	06e080e7          	jalr	110(ra) # 8000011a <kalloc>
    800010b4:	89aa                	mv	s3,a0
    800010b6:	36a4b023          	sd	a0,864(s1)
    800010ba:	c92d                	beqz	a0,8000112c <allocproc+0xd6>
  p->pagetable = proc_pagetable(p);
    800010bc:	8526                	mv	a0,s1
    800010be:	00000097          	auipc	ra,0x0
    800010c2:	e4c080e7          	jalr	-436(ra) # 80000f0a <proc_pagetable>
    800010c6:	89aa                	mv	s3,a0
    800010c8:	34a4bc23          	sd	a0,856(s1)
  if(p->pagetable == 0){
    800010cc:	cd25                	beqz	a0,80001144 <allocproc+0xee>
  memset(&p->context, 0, sizeof(p->context));
    800010ce:	07000613          	li	a2,112
    800010d2:	4581                	li	a1,0
    800010d4:	36848513          	addi	a0,s1,872
    800010d8:	fffff097          	auipc	ra,0xfffff
    800010dc:	0a2080e7          	jalr	162(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010e0:	00000797          	auipc	a5,0x0
    800010e4:	d9e78793          	addi	a5,a5,-610 # 80000e7e <forkret>
    800010e8:	36f4b423          	sd	a5,872(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010ec:	3484b783          	ld	a5,840(s1)
    800010f0:	6705                	lui	a4,0x1
    800010f2:	97ba                	add	a5,a5,a4
    800010f4:	36f4b823          	sd	a5,880(s1)
  for( int i=0 ; i<VMA_MAX ; i++ )
    800010f8:	01848793          	addi	a5,s1,24
    800010fc:	31848913          	addi	s2,s1,792
    p->vma[i].valid = 0;
    80001100:	0007a023          	sw	zero,0(a5)
    p->vma[i].mapcnt = 0;
    80001104:	0207b423          	sd	zero,40(a5)
  for( int i=0 ; i<VMA_MAX ; i++ )
    80001108:	03078793          	addi	a5,a5,48
    8000110c:	ff279ae3          	bne	a5,s2,80001100 <allocproc+0xaa>
  p->maxaddr = MAXVA - 2*PGSIZE;
    80001110:	020007b7          	lui	a5,0x2000
    80001114:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001116:	07b6                	slli	a5,a5,0xd
    80001118:	30f4bc23          	sd	a5,792(s1)
}
    8000111c:	8526                	mv	a0,s1
    8000111e:	70a2                	ld	ra,40(sp)
    80001120:	7402                	ld	s0,32(sp)
    80001122:	64e2                	ld	s1,24(sp)
    80001124:	6942                	ld	s2,16(sp)
    80001126:	69a2                	ld	s3,8(sp)
    80001128:	6145                	addi	sp,sp,48
    8000112a:	8082                	ret
    freeproc(p);
    8000112c:	8526                	mv	a0,s1
    8000112e:	00000097          	auipc	ra,0x0
    80001132:	eca080e7          	jalr	-310(ra) # 80000ff8 <freeproc>
    release(&p->lock);
    80001136:	8526                	mv	a0,s1
    80001138:	00005097          	auipc	ra,0x5
    8000113c:	5a6080e7          	jalr	1446(ra) # 800066de <release>
    return 0;
    80001140:	84ce                	mv	s1,s3
    80001142:	bfe9                	j	8000111c <allocproc+0xc6>
    freeproc(p);
    80001144:	8526                	mv	a0,s1
    80001146:	00000097          	auipc	ra,0x0
    8000114a:	eb2080e7          	jalr	-334(ra) # 80000ff8 <freeproc>
    release(&p->lock);
    8000114e:	8526                	mv	a0,s1
    80001150:	00005097          	auipc	ra,0x5
    80001154:	58e080e7          	jalr	1422(ra) # 800066de <release>
    return 0;
    80001158:	84ce                	mv	s1,s3
    8000115a:	b7c9                	j	8000111c <allocproc+0xc6>

000000008000115c <userinit>:
{
    8000115c:	1101                	addi	sp,sp,-32
    8000115e:	ec06                	sd	ra,24(sp)
    80001160:	e822                	sd	s0,16(sp)
    80001162:	e426                	sd	s1,8(sp)
    80001164:	1000                	addi	s0,sp,32
  p = allocproc();
    80001166:	00000097          	auipc	ra,0x0
    8000116a:	ef0080e7          	jalr	-272(ra) # 80001056 <allocproc>
    8000116e:	84aa                	mv	s1,a0
  initproc = p;
    80001170:	00008797          	auipc	a5,0x8
    80001174:	eaa7b023          	sd	a0,-352(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001178:	03400613          	li	a2,52
    8000117c:	00007597          	auipc	a1,0x7
    80001180:	71458593          	addi	a1,a1,1812 # 80008890 <initcode>
    80001184:	35853503          	ld	a0,856(a0)
    80001188:	fffff097          	auipc	ra,0xfffff
    8000118c:	672080e7          	jalr	1650(ra) # 800007fa <uvminit>
  p->sz = PGSIZE;
    80001190:	6785                	lui	a5,0x1
    80001192:	34f4b823          	sd	a5,848(s1)
  p->trapframe->epc = 0;      // user program counter
    80001196:	3604b703          	ld	a4,864(s1)
    8000119a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000119e:	3604b703          	ld	a4,864(s1)
    800011a2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011a4:	4641                	li	a2,16
    800011a6:	00007597          	auipc	a1,0x7
    800011aa:	fda58593          	addi	a1,a1,-38 # 80008180 <etext+0x180>
    800011ae:	46048513          	addi	a0,s1,1120
    800011b2:	fffff097          	auipc	ra,0xfffff
    800011b6:	112080e7          	jalr	274(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    800011ba:	00007517          	auipc	a0,0x7
    800011be:	fd650513          	addi	a0,a0,-42 # 80008190 <etext+0x190>
    800011c2:	00002097          	auipc	ra,0x2
    800011c6:	2e8080e7          	jalr	744(ra) # 800034aa <namei>
    800011ca:	44a4bc23          	sd	a0,1112(s1)
  p->state = RUNNABLE;
    800011ce:	478d                	li	a5,3
    800011d0:	32f4a023          	sw	a5,800(s1)
  release(&p->lock);
    800011d4:	8526                	mv	a0,s1
    800011d6:	00005097          	auipc	ra,0x5
    800011da:	508080e7          	jalr	1288(ra) # 800066de <release>
}
    800011de:	60e2                	ld	ra,24(sp)
    800011e0:	6442                	ld	s0,16(sp)
    800011e2:	64a2                	ld	s1,8(sp)
    800011e4:	6105                	addi	sp,sp,32
    800011e6:	8082                	ret

00000000800011e8 <growproc>:
{
    800011e8:	1101                	addi	sp,sp,-32
    800011ea:	ec06                	sd	ra,24(sp)
    800011ec:	e822                	sd	s0,16(sp)
    800011ee:	e426                	sd	s1,8(sp)
    800011f0:	e04a                	sd	s2,0(sp)
    800011f2:	1000                	addi	s0,sp,32
    800011f4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011f6:	00000097          	auipc	ra,0x0
    800011fa:	c50080e7          	jalr	-944(ra) # 80000e46 <myproc>
    800011fe:	892a                	mv	s2,a0
  sz = p->sz;
    80001200:	35053583          	ld	a1,848(a0)
    80001204:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001208:	00904f63          	bgtz	s1,80001226 <growproc+0x3e>
  } else if(n < 0){
    8000120c:	0204ce63          	bltz	s1,80001248 <growproc+0x60>
  p->sz = sz;
    80001210:	1782                	slli	a5,a5,0x20
    80001212:	9381                	srli	a5,a5,0x20
    80001214:	34f93823          	sd	a5,848(s2)
  return 0;
    80001218:	4501                	li	a0,0
}
    8000121a:	60e2                	ld	ra,24(sp)
    8000121c:	6442                	ld	s0,16(sp)
    8000121e:	64a2                	ld	s1,8(sp)
    80001220:	6902                	ld	s2,0(sp)
    80001222:	6105                	addi	sp,sp,32
    80001224:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001226:	00f4863b          	addw	a2,s1,a5
    8000122a:	1602                	slli	a2,a2,0x20
    8000122c:	9201                	srli	a2,a2,0x20
    8000122e:	1582                	slli	a1,a1,0x20
    80001230:	9181                	srli	a1,a1,0x20
    80001232:	35853503          	ld	a0,856(a0)
    80001236:	fffff097          	auipc	ra,0xfffff
    8000123a:	67e080e7          	jalr	1662(ra) # 800008b4 <uvmalloc>
    8000123e:	0005079b          	sext.w	a5,a0
    80001242:	f7f9                	bnez	a5,80001210 <growproc+0x28>
      return -1;
    80001244:	557d                	li	a0,-1
    80001246:	bfd1                	j	8000121a <growproc+0x32>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001248:	00f4863b          	addw	a2,s1,a5
    8000124c:	1602                	slli	a2,a2,0x20
    8000124e:	9201                	srli	a2,a2,0x20
    80001250:	1582                	slli	a1,a1,0x20
    80001252:	9181                	srli	a1,a1,0x20
    80001254:	35853503          	ld	a0,856(a0)
    80001258:	fffff097          	auipc	ra,0xfffff
    8000125c:	614080e7          	jalr	1556(ra) # 8000086c <uvmdealloc>
    80001260:	0005079b          	sext.w	a5,a0
    80001264:	b775                	j	80001210 <growproc+0x28>

0000000080001266 <fork>:
{
    80001266:	7139                	addi	sp,sp,-64
    80001268:	fc06                	sd	ra,56(sp)
    8000126a:	f822                	sd	s0,48(sp)
    8000126c:	f426                	sd	s1,40(sp)
    8000126e:	f04a                	sd	s2,32(sp)
    80001270:	ec4e                	sd	s3,24(sp)
    80001272:	e852                	sd	s4,16(sp)
    80001274:	e456                	sd	s5,8(sp)
    80001276:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001278:	00000097          	auipc	ra,0x0
    8000127c:	bce080e7          	jalr	-1074(ra) # 80000e46 <myproc>
    80001280:	8a2a                	mv	s4,a0
  if((np = allocproc()) == 0){
    80001282:	00000097          	auipc	ra,0x0
    80001286:	dd4080e7          	jalr	-556(ra) # 80001056 <allocproc>
    8000128a:	14050363          	beqz	a0,800013d0 <fork+0x16a>
    8000128e:	892a                	mv	s2,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001290:	350a3603          	ld	a2,848(s4)
    80001294:	35853583          	ld	a1,856(a0)
    80001298:	358a3503          	ld	a0,856(s4)
    8000129c:	fffff097          	auipc	ra,0xfffff
    800012a0:	768080e7          	jalr	1896(ra) # 80000a04 <uvmcopy>
    800012a4:	04054863          	bltz	a0,800012f4 <fork+0x8e>
  np->sz = p->sz;
    800012a8:	350a3783          	ld	a5,848(s4)
    800012ac:	34f93823          	sd	a5,848(s2)
  *(np->trapframe) = *(p->trapframe);
    800012b0:	360a3683          	ld	a3,864(s4)
    800012b4:	87b6                	mv	a5,a3
    800012b6:	36093703          	ld	a4,864(s2)
    800012ba:	12068693          	addi	a3,a3,288
    800012be:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012c2:	6788                	ld	a0,8(a5)
    800012c4:	6b8c                	ld	a1,16(a5)
    800012c6:	6f90                	ld	a2,24(a5)
    800012c8:	01073023          	sd	a6,0(a4)
    800012cc:	e708                	sd	a0,8(a4)
    800012ce:	eb0c                	sd	a1,16(a4)
    800012d0:	ef10                	sd	a2,24(a4)
    800012d2:	02078793          	addi	a5,a5,32
    800012d6:	02070713          	addi	a4,a4,32
    800012da:	fed792e3          	bne	a5,a3,800012be <fork+0x58>
  np->trapframe->a0 = 0;
    800012de:	36093783          	ld	a5,864(s2)
    800012e2:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012e6:	3d8a0493          	addi	s1,s4,984
    800012ea:	3d890993          	addi	s3,s2,984
    800012ee:	458a0a93          	addi	s5,s4,1112
    800012f2:	a00d                	j	80001314 <fork+0xae>
    freeproc(np);
    800012f4:	854a                	mv	a0,s2
    800012f6:	00000097          	auipc	ra,0x0
    800012fa:	d02080e7          	jalr	-766(ra) # 80000ff8 <freeproc>
    release(&np->lock);
    800012fe:	854a                	mv	a0,s2
    80001300:	00005097          	auipc	ra,0x5
    80001304:	3de080e7          	jalr	990(ra) # 800066de <release>
    return -1;
    80001308:	5afd                	li	s5,-1
    8000130a:	a0e1                	j	800013d2 <fork+0x16c>
  for(i = 0; i < NOFILE; i++)
    8000130c:	04a1                	addi	s1,s1,8
    8000130e:	09a1                	addi	s3,s3,8
    80001310:	01548b63          	beq	s1,s5,80001326 <fork+0xc0>
    if(p->ofile[i])
    80001314:	6088                	ld	a0,0(s1)
    80001316:	d97d                	beqz	a0,8000130c <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001318:	00003097          	auipc	ra,0x3
    8000131c:	82c080e7          	jalr	-2004(ra) # 80003b44 <filedup>
    80001320:	00a9b023          	sd	a0,0(s3)
    80001324:	b7e5                	j	8000130c <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001326:	458a3503          	ld	a0,1112(s4)
    8000132a:	00002097          	auipc	ra,0x2
    8000132e:	986080e7          	jalr	-1658(ra) # 80002cb0 <idup>
    80001332:	44a93c23          	sd	a0,1112(s2)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001336:	4641                	li	a2,16
    80001338:	460a0593          	addi	a1,s4,1120
    8000133c:	46090513          	addi	a0,s2,1120
    80001340:	fffff097          	auipc	ra,0xfffff
    80001344:	f84080e7          	jalr	-124(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    80001348:	33892a83          	lw	s5,824(s2)
  release(&np->lock);
    8000134c:	854a                	mv	a0,s2
    8000134e:	00005097          	auipc	ra,0x5
    80001352:	390080e7          	jalr	912(ra) # 800066de <release>
  acquire(&wait_lock);
    80001356:	00008497          	auipc	s1,0x8
    8000135a:	d1248493          	addi	s1,s1,-750 # 80009068 <wait_lock>
    8000135e:	8526                	mv	a0,s1
    80001360:	00005097          	auipc	ra,0x5
    80001364:	2ca080e7          	jalr	714(ra) # 8000662a <acquire>
  np->parent = p;
    80001368:	35493023          	sd	s4,832(s2)
  release(&wait_lock);
    8000136c:	8526                	mv	a0,s1
    8000136e:	00005097          	auipc	ra,0x5
    80001372:	370080e7          	jalr	880(ra) # 800066de <release>
  acquire(&np->lock);
    80001376:	854a                	mv	a0,s2
    80001378:	00005097          	auipc	ra,0x5
    8000137c:	2b2080e7          	jalr	690(ra) # 8000662a <acquire>
  np->state = RUNNABLE;
    80001380:	478d                	li	a5,3
    80001382:	32f92023          	sw	a5,800(s2)
  release(&np->lock);
    80001386:	854a                	mv	a0,s2
    80001388:	00005097          	auipc	ra,0x5
    8000138c:	356080e7          	jalr	854(ra) # 800066de <release>
   np->maxaddr = p->maxaddr;
    80001390:	318a3783          	ld	a5,792(s4)
    80001394:	30f93c23          	sd	a5,792(s2)
  for( int i=0 ; i<VMA_MAX ; i++ )
    80001398:	018a0493          	addi	s1,s4,24
    8000139c:	0961                	addi	s2,s2,24
    8000139e:	318a0a13          	addi	s4,s4,792
    800013a2:	a039                	j	800013b0 <fork+0x14a>
    800013a4:	03048493          	addi	s1,s1,48
    800013a8:	03090913          	addi	s2,s2,48
    800013ac:	03448363          	beq	s1,s4,800013d2 <fork+0x16c>
    if( p->vma[i].valid )
    800013b0:	409c                	lw	a5,0(s1)
    800013b2:	dbed                	beqz	a5,800013a4 <fork+0x13e>
      filedup( p->vma[i].f );
    800013b4:	7088                	ld	a0,32(s1)
    800013b6:	00002097          	auipc	ra,0x2
    800013ba:	78e080e7          	jalr	1934(ra) # 80003b44 <filedup>
      memmove( &np->vma[i] , &p->vma[i] , sizeof( struct VMA ));
    800013be:	03000613          	li	a2,48
    800013c2:	85a6                	mv	a1,s1
    800013c4:	854a                	mv	a0,s2
    800013c6:	fffff097          	auipc	ra,0xfffff
    800013ca:	e10080e7          	jalr	-496(ra) # 800001d6 <memmove>
    800013ce:	bfd9                	j	800013a4 <fork+0x13e>
    return -1;
    800013d0:	5afd                	li	s5,-1
}
    800013d2:	8556                	mv	a0,s5
    800013d4:	70e2                	ld	ra,56(sp)
    800013d6:	7442                	ld	s0,48(sp)
    800013d8:	74a2                	ld	s1,40(sp)
    800013da:	7902                	ld	s2,32(sp)
    800013dc:	69e2                	ld	s3,24(sp)
    800013de:	6a42                	ld	s4,16(sp)
    800013e0:	6aa2                	ld	s5,8(sp)
    800013e2:	6121                	addi	sp,sp,64
    800013e4:	8082                	ret

00000000800013e6 <scheduler>:
{
    800013e6:	7139                	addi	sp,sp,-64
    800013e8:	fc06                	sd	ra,56(sp)
    800013ea:	f822                	sd	s0,48(sp)
    800013ec:	f426                	sd	s1,40(sp)
    800013ee:	f04a                	sd	s2,32(sp)
    800013f0:	ec4e                	sd	s3,24(sp)
    800013f2:	e852                	sd	s4,16(sp)
    800013f4:	e456                	sd	s5,8(sp)
    800013f6:	e05a                	sd	s6,0(sp)
    800013f8:	0080                	addi	s0,sp,64
    800013fa:	8792                	mv	a5,tp
  int id = r_tp();
    800013fc:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013fe:	00779a93          	slli	s5,a5,0x7
    80001402:	00008717          	auipc	a4,0x8
    80001406:	c4e70713          	addi	a4,a4,-946 # 80009050 <pid_lock>
    8000140a:	9756                	add	a4,a4,s5
    8000140c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001410:	00008717          	auipc	a4,0x8
    80001414:	c7870713          	addi	a4,a4,-904 # 80009088 <cpus+0x8>
    80001418:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000141a:	498d                	li	s3,3
        p->state = RUNNING;
    8000141c:	4b11                	li	s6,4
        c->proc = p;
    8000141e:	079e                	slli	a5,a5,0x7
    80001420:	00008a17          	auipc	s4,0x8
    80001424:	c30a0a13          	addi	s4,s4,-976 # 80009050 <pid_lock>
    80001428:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000142a:	0001a917          	auipc	s2,0x1a
    8000142e:	c5690913          	addi	s2,s2,-938 # 8001b080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001432:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001436:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000143a:	10079073          	csrw	sstatus,a5
    8000143e:	00008497          	auipc	s1,0x8
    80001442:	04248493          	addi	s1,s1,66 # 80009480 <proc>
    80001446:	a811                	j	8000145a <scheduler+0x74>
      release(&p->lock);
    80001448:	8526                	mv	a0,s1
    8000144a:	00005097          	auipc	ra,0x5
    8000144e:	294080e7          	jalr	660(ra) # 800066de <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001452:	47048493          	addi	s1,s1,1136
    80001456:	fd248ee3          	beq	s1,s2,80001432 <scheduler+0x4c>
      acquire(&p->lock);
    8000145a:	8526                	mv	a0,s1
    8000145c:	00005097          	auipc	ra,0x5
    80001460:	1ce080e7          	jalr	462(ra) # 8000662a <acquire>
      if(p->state == RUNNABLE) {
    80001464:	3204a783          	lw	a5,800(s1)
    80001468:	ff3790e3          	bne	a5,s3,80001448 <scheduler+0x62>
        p->state = RUNNING;
    8000146c:	3364a023          	sw	s6,800(s1)
        c->proc = p;
    80001470:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001474:	36848593          	addi	a1,s1,872
    80001478:	8556                	mv	a0,s5
    8000147a:	00000097          	auipc	ra,0x0
    8000147e:	6da080e7          	jalr	1754(ra) # 80001b54 <swtch>
        c->proc = 0;
    80001482:	020a3823          	sd	zero,48(s4)
    80001486:	b7c9                	j	80001448 <scheduler+0x62>

0000000080001488 <sched>:
{
    80001488:	7179                	addi	sp,sp,-48
    8000148a:	f406                	sd	ra,40(sp)
    8000148c:	f022                	sd	s0,32(sp)
    8000148e:	ec26                	sd	s1,24(sp)
    80001490:	e84a                	sd	s2,16(sp)
    80001492:	e44e                	sd	s3,8(sp)
    80001494:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001496:	00000097          	auipc	ra,0x0
    8000149a:	9b0080e7          	jalr	-1616(ra) # 80000e46 <myproc>
    8000149e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800014a0:	00005097          	auipc	ra,0x5
    800014a4:	110080e7          	jalr	272(ra) # 800065b0 <holding>
    800014a8:	cd25                	beqz	a0,80001520 <sched+0x98>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014aa:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800014ac:	2781                	sext.w	a5,a5
    800014ae:	079e                	slli	a5,a5,0x7
    800014b0:	00008717          	auipc	a4,0x8
    800014b4:	ba070713          	addi	a4,a4,-1120 # 80009050 <pid_lock>
    800014b8:	97ba                	add	a5,a5,a4
    800014ba:	0a87a703          	lw	a4,168(a5)
    800014be:	4785                	li	a5,1
    800014c0:	06f71863          	bne	a4,a5,80001530 <sched+0xa8>
  if(p->state == RUNNING)
    800014c4:	3204a703          	lw	a4,800(s1)
    800014c8:	4791                	li	a5,4
    800014ca:	06f70b63          	beq	a4,a5,80001540 <sched+0xb8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014ce:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014d2:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014d4:	efb5                	bnez	a5,80001550 <sched+0xc8>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014d6:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014d8:	00008917          	auipc	s2,0x8
    800014dc:	b7890913          	addi	s2,s2,-1160 # 80009050 <pid_lock>
    800014e0:	2781                	sext.w	a5,a5
    800014e2:	079e                	slli	a5,a5,0x7
    800014e4:	97ca                	add	a5,a5,s2
    800014e6:	0ac7a983          	lw	s3,172(a5)
    800014ea:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014ec:	2781                	sext.w	a5,a5
    800014ee:	079e                	slli	a5,a5,0x7
    800014f0:	00008597          	auipc	a1,0x8
    800014f4:	b9858593          	addi	a1,a1,-1128 # 80009088 <cpus+0x8>
    800014f8:	95be                	add	a1,a1,a5
    800014fa:	36848513          	addi	a0,s1,872
    800014fe:	00000097          	auipc	ra,0x0
    80001502:	656080e7          	jalr	1622(ra) # 80001b54 <swtch>
    80001506:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001508:	2781                	sext.w	a5,a5
    8000150a:	079e                	slli	a5,a5,0x7
    8000150c:	993e                	add	s2,s2,a5
    8000150e:	0b392623          	sw	s3,172(s2)
}
    80001512:	70a2                	ld	ra,40(sp)
    80001514:	7402                	ld	s0,32(sp)
    80001516:	64e2                	ld	s1,24(sp)
    80001518:	6942                	ld	s2,16(sp)
    8000151a:	69a2                	ld	s3,8(sp)
    8000151c:	6145                	addi	sp,sp,48
    8000151e:	8082                	ret
    panic("sched p->lock");
    80001520:	00007517          	auipc	a0,0x7
    80001524:	c7850513          	addi	a0,a0,-904 # 80008198 <etext+0x198>
    80001528:	00005097          	auipc	ra,0x5
    8000152c:	bca080e7          	jalr	-1078(ra) # 800060f2 <panic>
    panic("sched locks");
    80001530:	00007517          	auipc	a0,0x7
    80001534:	c7850513          	addi	a0,a0,-904 # 800081a8 <etext+0x1a8>
    80001538:	00005097          	auipc	ra,0x5
    8000153c:	bba080e7          	jalr	-1094(ra) # 800060f2 <panic>
    panic("sched running");
    80001540:	00007517          	auipc	a0,0x7
    80001544:	c7850513          	addi	a0,a0,-904 # 800081b8 <etext+0x1b8>
    80001548:	00005097          	auipc	ra,0x5
    8000154c:	baa080e7          	jalr	-1110(ra) # 800060f2 <panic>
    panic("sched interruptible");
    80001550:	00007517          	auipc	a0,0x7
    80001554:	c7850513          	addi	a0,a0,-904 # 800081c8 <etext+0x1c8>
    80001558:	00005097          	auipc	ra,0x5
    8000155c:	b9a080e7          	jalr	-1126(ra) # 800060f2 <panic>

0000000080001560 <yield>:
{
    80001560:	1101                	addi	sp,sp,-32
    80001562:	ec06                	sd	ra,24(sp)
    80001564:	e822                	sd	s0,16(sp)
    80001566:	e426                	sd	s1,8(sp)
    80001568:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000156a:	00000097          	auipc	ra,0x0
    8000156e:	8dc080e7          	jalr	-1828(ra) # 80000e46 <myproc>
    80001572:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001574:	00005097          	auipc	ra,0x5
    80001578:	0b6080e7          	jalr	182(ra) # 8000662a <acquire>
  p->state = RUNNABLE;
    8000157c:	478d                	li	a5,3
    8000157e:	32f4a023          	sw	a5,800(s1)
  sched();
    80001582:	00000097          	auipc	ra,0x0
    80001586:	f06080e7          	jalr	-250(ra) # 80001488 <sched>
  release(&p->lock);
    8000158a:	8526                	mv	a0,s1
    8000158c:	00005097          	auipc	ra,0x5
    80001590:	152080e7          	jalr	338(ra) # 800066de <release>
}
    80001594:	60e2                	ld	ra,24(sp)
    80001596:	6442                	ld	s0,16(sp)
    80001598:	64a2                	ld	s1,8(sp)
    8000159a:	6105                	addi	sp,sp,32
    8000159c:	8082                	ret

000000008000159e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000159e:	7179                	addi	sp,sp,-48
    800015a0:	f406                	sd	ra,40(sp)
    800015a2:	f022                	sd	s0,32(sp)
    800015a4:	ec26                	sd	s1,24(sp)
    800015a6:	e84a                	sd	s2,16(sp)
    800015a8:	e44e                	sd	s3,8(sp)
    800015aa:	1800                	addi	s0,sp,48
    800015ac:	89aa                	mv	s3,a0
    800015ae:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015b0:	00000097          	auipc	ra,0x0
    800015b4:	896080e7          	jalr	-1898(ra) # 80000e46 <myproc>
    800015b8:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015ba:	00005097          	auipc	ra,0x5
    800015be:	070080e7          	jalr	112(ra) # 8000662a <acquire>
  release(lk);
    800015c2:	854a                	mv	a0,s2
    800015c4:	00005097          	auipc	ra,0x5
    800015c8:	11a080e7          	jalr	282(ra) # 800066de <release>

  // Go to sleep.
  p->chan = chan;
    800015cc:	3334b423          	sd	s3,808(s1)
  p->state = SLEEPING;
    800015d0:	4789                	li	a5,2
    800015d2:	32f4a023          	sw	a5,800(s1)

  sched();
    800015d6:	00000097          	auipc	ra,0x0
    800015da:	eb2080e7          	jalr	-334(ra) # 80001488 <sched>

  // Tidy up.
  p->chan = 0;
    800015de:	3204b423          	sd	zero,808(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015e2:	8526                	mv	a0,s1
    800015e4:	00005097          	auipc	ra,0x5
    800015e8:	0fa080e7          	jalr	250(ra) # 800066de <release>
  acquire(lk);
    800015ec:	854a                	mv	a0,s2
    800015ee:	00005097          	auipc	ra,0x5
    800015f2:	03c080e7          	jalr	60(ra) # 8000662a <acquire>
}
    800015f6:	70a2                	ld	ra,40(sp)
    800015f8:	7402                	ld	s0,32(sp)
    800015fa:	64e2                	ld	s1,24(sp)
    800015fc:	6942                	ld	s2,16(sp)
    800015fe:	69a2                	ld	s3,8(sp)
    80001600:	6145                	addi	sp,sp,48
    80001602:	8082                	ret

0000000080001604 <wait>:
{
    80001604:	715d                	addi	sp,sp,-80
    80001606:	e486                	sd	ra,72(sp)
    80001608:	e0a2                	sd	s0,64(sp)
    8000160a:	fc26                	sd	s1,56(sp)
    8000160c:	f84a                	sd	s2,48(sp)
    8000160e:	f44e                	sd	s3,40(sp)
    80001610:	f052                	sd	s4,32(sp)
    80001612:	ec56                	sd	s5,24(sp)
    80001614:	e85a                	sd	s6,16(sp)
    80001616:	e45e                	sd	s7,8(sp)
    80001618:	e062                	sd	s8,0(sp)
    8000161a:	0880                	addi	s0,sp,80
    8000161c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000161e:	00000097          	auipc	ra,0x0
    80001622:	828080e7          	jalr	-2008(ra) # 80000e46 <myproc>
    80001626:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001628:	00008517          	auipc	a0,0x8
    8000162c:	a4050513          	addi	a0,a0,-1472 # 80009068 <wait_lock>
    80001630:	00005097          	auipc	ra,0x5
    80001634:	ffa080e7          	jalr	-6(ra) # 8000662a <acquire>
    havekids = 0;
    80001638:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000163a:	4a15                	li	s4,5
        havekids = 1;
    8000163c:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000163e:	0001a997          	auipc	s3,0x1a
    80001642:	a4298993          	addi	s3,s3,-1470 # 8001b080 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001646:	00008c17          	auipc	s8,0x8
    8000164a:	a22c0c13          	addi	s8,s8,-1502 # 80009068 <wait_lock>
    havekids = 0;
    8000164e:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001650:	00008497          	auipc	s1,0x8
    80001654:	e3048493          	addi	s1,s1,-464 # 80009480 <proc>
    80001658:	a0bd                	j	800016c6 <wait+0xc2>
          pid = np->pid;
    8000165a:	3384a983          	lw	s3,824(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000165e:	000b0e63          	beqz	s6,8000167a <wait+0x76>
    80001662:	4691                	li	a3,4
    80001664:	33448613          	addi	a2,s1,820
    80001668:	85da                	mv	a1,s6
    8000166a:	35893503          	ld	a0,856(s2)
    8000166e:	fffff097          	auipc	ra,0xfffff
    80001672:	49a080e7          	jalr	1178(ra) # 80000b08 <copyout>
    80001676:	02054563          	bltz	a0,800016a0 <wait+0x9c>
          freeproc(np);
    8000167a:	8526                	mv	a0,s1
    8000167c:	00000097          	auipc	ra,0x0
    80001680:	97c080e7          	jalr	-1668(ra) # 80000ff8 <freeproc>
          release(&np->lock);
    80001684:	8526                	mv	a0,s1
    80001686:	00005097          	auipc	ra,0x5
    8000168a:	058080e7          	jalr	88(ra) # 800066de <release>
          release(&wait_lock);
    8000168e:	00008517          	auipc	a0,0x8
    80001692:	9da50513          	addi	a0,a0,-1574 # 80009068 <wait_lock>
    80001696:	00005097          	auipc	ra,0x5
    8000169a:	048080e7          	jalr	72(ra) # 800066de <release>
          return pid;
    8000169e:	a0ad                	j	80001708 <wait+0x104>
            release(&np->lock);
    800016a0:	8526                	mv	a0,s1
    800016a2:	00005097          	auipc	ra,0x5
    800016a6:	03c080e7          	jalr	60(ra) # 800066de <release>
            release(&wait_lock);
    800016aa:	00008517          	auipc	a0,0x8
    800016ae:	9be50513          	addi	a0,a0,-1602 # 80009068 <wait_lock>
    800016b2:	00005097          	auipc	ra,0x5
    800016b6:	02c080e7          	jalr	44(ra) # 800066de <release>
            return -1;
    800016ba:	59fd                	li	s3,-1
    800016bc:	a0b1                	j	80001708 <wait+0x104>
    for(np = proc; np < &proc[NPROC]; np++){
    800016be:	47048493          	addi	s1,s1,1136
    800016c2:	03348663          	beq	s1,s3,800016ee <wait+0xea>
      if(np->parent == p){
    800016c6:	3404b783          	ld	a5,832(s1)
    800016ca:	ff279ae3          	bne	a5,s2,800016be <wait+0xba>
        acquire(&np->lock);
    800016ce:	8526                	mv	a0,s1
    800016d0:	00005097          	auipc	ra,0x5
    800016d4:	f5a080e7          	jalr	-166(ra) # 8000662a <acquire>
        if(np->state == ZOMBIE){
    800016d8:	3204a783          	lw	a5,800(s1)
    800016dc:	f7478fe3          	beq	a5,s4,8000165a <wait+0x56>
        release(&np->lock);
    800016e0:	8526                	mv	a0,s1
    800016e2:	00005097          	auipc	ra,0x5
    800016e6:	ffc080e7          	jalr	-4(ra) # 800066de <release>
        havekids = 1;
    800016ea:	8756                	mv	a4,s5
    800016ec:	bfc9                	j	800016be <wait+0xba>
    if(!havekids || p->killed){
    800016ee:	c701                	beqz	a4,800016f6 <wait+0xf2>
    800016f0:	33092783          	lw	a5,816(s2)
    800016f4:	c79d                	beqz	a5,80001722 <wait+0x11e>
      release(&wait_lock);
    800016f6:	00008517          	auipc	a0,0x8
    800016fa:	97250513          	addi	a0,a0,-1678 # 80009068 <wait_lock>
    800016fe:	00005097          	auipc	ra,0x5
    80001702:	fe0080e7          	jalr	-32(ra) # 800066de <release>
      return -1;
    80001706:	59fd                	li	s3,-1
}
    80001708:	854e                	mv	a0,s3
    8000170a:	60a6                	ld	ra,72(sp)
    8000170c:	6406                	ld	s0,64(sp)
    8000170e:	74e2                	ld	s1,56(sp)
    80001710:	7942                	ld	s2,48(sp)
    80001712:	79a2                	ld	s3,40(sp)
    80001714:	7a02                	ld	s4,32(sp)
    80001716:	6ae2                	ld	s5,24(sp)
    80001718:	6b42                	ld	s6,16(sp)
    8000171a:	6ba2                	ld	s7,8(sp)
    8000171c:	6c02                	ld	s8,0(sp)
    8000171e:	6161                	addi	sp,sp,80
    80001720:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001722:	85e2                	mv	a1,s8
    80001724:	854a                	mv	a0,s2
    80001726:	00000097          	auipc	ra,0x0
    8000172a:	e78080e7          	jalr	-392(ra) # 8000159e <sleep>
    havekids = 0;
    8000172e:	b705                	j	8000164e <wait+0x4a>

0000000080001730 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001730:	7139                	addi	sp,sp,-64
    80001732:	fc06                	sd	ra,56(sp)
    80001734:	f822                	sd	s0,48(sp)
    80001736:	f426                	sd	s1,40(sp)
    80001738:	f04a                	sd	s2,32(sp)
    8000173a:	ec4e                	sd	s3,24(sp)
    8000173c:	e852                	sd	s4,16(sp)
    8000173e:	e456                	sd	s5,8(sp)
    80001740:	0080                	addi	s0,sp,64
    80001742:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001744:	00008497          	auipc	s1,0x8
    80001748:	d3c48493          	addi	s1,s1,-708 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000174c:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000174e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001750:	0001a917          	auipc	s2,0x1a
    80001754:	93090913          	addi	s2,s2,-1744 # 8001b080 <tickslock>
    80001758:	a811                	j	8000176c <wakeup+0x3c>
      }
      release(&p->lock);
    8000175a:	8526                	mv	a0,s1
    8000175c:	00005097          	auipc	ra,0x5
    80001760:	f82080e7          	jalr	-126(ra) # 800066de <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001764:	47048493          	addi	s1,s1,1136
    80001768:	03248863          	beq	s1,s2,80001798 <wakeup+0x68>
    if(p != myproc()){
    8000176c:	fffff097          	auipc	ra,0xfffff
    80001770:	6da080e7          	jalr	1754(ra) # 80000e46 <myproc>
    80001774:	fea488e3          	beq	s1,a0,80001764 <wakeup+0x34>
      acquire(&p->lock);
    80001778:	8526                	mv	a0,s1
    8000177a:	00005097          	auipc	ra,0x5
    8000177e:	eb0080e7          	jalr	-336(ra) # 8000662a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001782:	3204a783          	lw	a5,800(s1)
    80001786:	fd379ae3          	bne	a5,s3,8000175a <wakeup+0x2a>
    8000178a:	3284b783          	ld	a5,808(s1)
    8000178e:	fd4796e3          	bne	a5,s4,8000175a <wakeup+0x2a>
        p->state = RUNNABLE;
    80001792:	3354a023          	sw	s5,800(s1)
    80001796:	b7d1                	j	8000175a <wakeup+0x2a>
    }
  }
}
    80001798:	70e2                	ld	ra,56(sp)
    8000179a:	7442                	ld	s0,48(sp)
    8000179c:	74a2                	ld	s1,40(sp)
    8000179e:	7902                	ld	s2,32(sp)
    800017a0:	69e2                	ld	s3,24(sp)
    800017a2:	6a42                	ld	s4,16(sp)
    800017a4:	6aa2                	ld	s5,8(sp)
    800017a6:	6121                	addi	sp,sp,64
    800017a8:	8082                	ret

00000000800017aa <reparent>:
{
    800017aa:	7179                	addi	sp,sp,-48
    800017ac:	f406                	sd	ra,40(sp)
    800017ae:	f022                	sd	s0,32(sp)
    800017b0:	ec26                	sd	s1,24(sp)
    800017b2:	e84a                	sd	s2,16(sp)
    800017b4:	e44e                	sd	s3,8(sp)
    800017b6:	e052                	sd	s4,0(sp)
    800017b8:	1800                	addi	s0,sp,48
    800017ba:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017bc:	00008497          	auipc	s1,0x8
    800017c0:	cc448493          	addi	s1,s1,-828 # 80009480 <proc>
      pp->parent = initproc;
    800017c4:	00008a17          	auipc	s4,0x8
    800017c8:	84ca0a13          	addi	s4,s4,-1972 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017cc:	0001a997          	auipc	s3,0x1a
    800017d0:	8b498993          	addi	s3,s3,-1868 # 8001b080 <tickslock>
    800017d4:	a029                	j	800017de <reparent+0x34>
    800017d6:	47048493          	addi	s1,s1,1136
    800017da:	01348f63          	beq	s1,s3,800017f8 <reparent+0x4e>
    if(pp->parent == p){
    800017de:	3404b783          	ld	a5,832(s1)
    800017e2:	ff279ae3          	bne	a5,s2,800017d6 <reparent+0x2c>
      pp->parent = initproc;
    800017e6:	000a3503          	ld	a0,0(s4)
    800017ea:	34a4b023          	sd	a0,832(s1)
      wakeup(initproc);
    800017ee:	00000097          	auipc	ra,0x0
    800017f2:	f42080e7          	jalr	-190(ra) # 80001730 <wakeup>
    800017f6:	b7c5                	j	800017d6 <reparent+0x2c>
}
    800017f8:	70a2                	ld	ra,40(sp)
    800017fa:	7402                	ld	s0,32(sp)
    800017fc:	64e2                	ld	s1,24(sp)
    800017fe:	6942                	ld	s2,16(sp)
    80001800:	69a2                	ld	s3,8(sp)
    80001802:	6a02                	ld	s4,0(sp)
    80001804:	6145                	addi	sp,sp,48
    80001806:	8082                	ret

0000000080001808 <exit>:
{
    80001808:	715d                	addi	sp,sp,-80
    8000180a:	e486                	sd	ra,72(sp)
    8000180c:	e0a2                	sd	s0,64(sp)
    8000180e:	fc26                	sd	s1,56(sp)
    80001810:	f84a                	sd	s2,48(sp)
    80001812:	f44e                	sd	s3,40(sp)
    80001814:	f052                	sd	s4,32(sp)
    80001816:	ec56                	sd	s5,24(sp)
    80001818:	e85a                	sd	s6,16(sp)
    8000181a:	e45e                	sd	s7,8(sp)
    8000181c:	e062                	sd	s8,0(sp)
    8000181e:	0880                	addi	s0,sp,80
    80001820:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80001822:	fffff097          	auipc	ra,0xfffff
    80001826:	624080e7          	jalr	1572(ra) # 80000e46 <myproc>
    8000182a:	8aaa                	mv	s5,a0
  for( int i=0 ; i<VMA_MAX ; i++ )
    8000182c:	01850913          	addi	s2,a0,24
    80001830:	31850c13          	addi	s8,a0,792
    if( p->vma[i].valid == 1 )
    80001834:	4a05                	li	s4,1
      for( uint64 addr = vp->addr ; addr < vp->addr + vp->len ; addr += PGSIZE )
    80001836:	6b05                	lui	s6,0x1
    80001838:	a0bd                	j	800018a6 <exit+0x9e>
          uvmunmap( p->pagetable , addr , 1 , 1 );
    8000183a:	86d2                	mv	a3,s4
    8000183c:	8652                	mv	a2,s4
    8000183e:	85a6                	mv	a1,s1
    80001840:	358ab503          	ld	a0,856(s5)
    80001844:	fffff097          	auipc	ra,0xfffff
    80001848:	ec4080e7          	jalr	-316(ra) # 80000708 <uvmunmap>
      for( uint64 addr = vp->addr ; addr < vp->addr + vp->len ; addr += PGSIZE )
    8000184c:	94da                	add	s1,s1,s6
    8000184e:	0109a783          	lw	a5,16(s3)
    80001852:	0089b703          	ld	a4,8(s3)
    80001856:	97ba                	add	a5,a5,a4
    80001858:	02f4fb63          	bgeu	s1,a5,8000188e <exit+0x86>
        if( walkaddr( p->pagetable , addr ) != 0 )
    8000185c:	85a6                	mv	a1,s1
    8000185e:	358ab503          	ld	a0,856(s5)
    80001862:	fffff097          	auipc	ra,0xfffff
    80001866:	c9e080e7          	jalr	-866(ra) # 80000500 <walkaddr>
    8000186a:	d16d                	beqz	a0,8000184c <exit+0x44>
          if( vp->flags == MAP_SHARED )
    8000186c:	0189a783          	lw	a5,24(s3)
    80001870:	fd4795e3          	bne	a5,s4,8000183a <exit+0x32>
            filewriteoff( vp->f , addr , PGSIZE , addr-vp->addr);
    80001874:	0089b683          	ld	a3,8(s3)
    80001878:	40d486bb          	subw	a3,s1,a3
    8000187c:	865a                	mv	a2,s6
    8000187e:	85a6                	mv	a1,s1
    80001880:	0209b503          	ld	a0,32(s3)
    80001884:	00002097          	auipc	ra,0x2
    80001888:	642080e7          	jalr	1602(ra) # 80003ec6 <filewriteoff>
    8000188c:	b77d                	j	8000183a <exit+0x32>
      fileclose( p->vma[i].f );
    8000188e:	0209b503          	ld	a0,32(s3)
    80001892:	00002097          	auipc	ra,0x2
    80001896:	304080e7          	jalr	772(ra) # 80003b96 <fileclose>
      p->vma[i].valid = 0;
    8000189a:	0009a023          	sw	zero,0(s3)
  for( int i=0 ; i<VMA_MAX ; i++ )
    8000189e:	03090913          	addi	s2,s2,48
    800018a2:	01890f63          	beq	s2,s8,800018c0 <exit+0xb8>
    if( p->vma[i].valid == 1 )
    800018a6:	89ca                	mv	s3,s2
    800018a8:	00092783          	lw	a5,0(s2)
    800018ac:	ff4799e3          	bne	a5,s4,8000189e <exit+0x96>
      for( uint64 addr = vp->addr ; addr < vp->addr + vp->len ; addr += PGSIZE )
    800018b0:	00893483          	ld	s1,8(s2)
    800018b4:	01092783          	lw	a5,16(s2)
    800018b8:	97a6                	add	a5,a5,s1
    800018ba:	faf4e1e3          	bltu	s1,a5,8000185c <exit+0x54>
    800018be:	bfc1                	j	8000188e <exit+0x86>
  if(p == initproc)
    800018c0:	00007797          	auipc	a5,0x7
    800018c4:	7507b783          	ld	a5,1872(a5) # 80009010 <initproc>
    800018c8:	3d8a8493          	addi	s1,s5,984
    800018cc:	458a8913          	addi	s2,s5,1112
    800018d0:	01579d63          	bne	a5,s5,800018ea <exit+0xe2>
    panic("init exiting");
    800018d4:	00007517          	auipc	a0,0x7
    800018d8:	90c50513          	addi	a0,a0,-1780 # 800081e0 <etext+0x1e0>
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	816080e7          	jalr	-2026(ra) # 800060f2 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800018e4:	04a1                	addi	s1,s1,8
    800018e6:	01248b63          	beq	s1,s2,800018fc <exit+0xf4>
    if(p->ofile[fd]){
    800018ea:	6088                	ld	a0,0(s1)
    800018ec:	dd65                	beqz	a0,800018e4 <exit+0xdc>
      fileclose(f);
    800018ee:	00002097          	auipc	ra,0x2
    800018f2:	2a8080e7          	jalr	680(ra) # 80003b96 <fileclose>
      p->ofile[fd] = 0;
    800018f6:	0004b023          	sd	zero,0(s1)
    800018fa:	b7ed                	j	800018e4 <exit+0xdc>
  begin_op();
    800018fc:	00002097          	auipc	ra,0x2
    80001900:	dce080e7          	jalr	-562(ra) # 800036ca <begin_op>
  iput(p->cwd);
    80001904:	458ab503          	ld	a0,1112(s5)
    80001908:	00001097          	auipc	ra,0x1
    8000190c:	5a0080e7          	jalr	1440(ra) # 80002ea8 <iput>
  end_op();
    80001910:	00002097          	auipc	ra,0x2
    80001914:	e38080e7          	jalr	-456(ra) # 80003748 <end_op>
  p->cwd = 0;
    80001918:	440abc23          	sd	zero,1112(s5)
  acquire(&wait_lock);
    8000191c:	00007497          	auipc	s1,0x7
    80001920:	74c48493          	addi	s1,s1,1868 # 80009068 <wait_lock>
    80001924:	8526                	mv	a0,s1
    80001926:	00005097          	auipc	ra,0x5
    8000192a:	d04080e7          	jalr	-764(ra) # 8000662a <acquire>
  reparent(p);
    8000192e:	8556                	mv	a0,s5
    80001930:	00000097          	auipc	ra,0x0
    80001934:	e7a080e7          	jalr	-390(ra) # 800017aa <reparent>
  wakeup(p->parent);
    80001938:	340ab503          	ld	a0,832(s5)
    8000193c:	00000097          	auipc	ra,0x0
    80001940:	df4080e7          	jalr	-524(ra) # 80001730 <wakeup>
  acquire(&p->lock);
    80001944:	8556                	mv	a0,s5
    80001946:	00005097          	auipc	ra,0x5
    8000194a:	ce4080e7          	jalr	-796(ra) # 8000662a <acquire>
  p->xstate = status;
    8000194e:	337aaa23          	sw	s7,820(s5)
  p->state = ZOMBIE;
    80001952:	4795                	li	a5,5
    80001954:	32faa023          	sw	a5,800(s5)
  release(&wait_lock);
    80001958:	8526                	mv	a0,s1
    8000195a:	00005097          	auipc	ra,0x5
    8000195e:	d84080e7          	jalr	-636(ra) # 800066de <release>
  sched();
    80001962:	00000097          	auipc	ra,0x0
    80001966:	b26080e7          	jalr	-1242(ra) # 80001488 <sched>
  panic("zombie exit");
    8000196a:	00007517          	auipc	a0,0x7
    8000196e:	88650513          	addi	a0,a0,-1914 # 800081f0 <etext+0x1f0>
    80001972:	00004097          	auipc	ra,0x4
    80001976:	780080e7          	jalr	1920(ra) # 800060f2 <panic>

000000008000197a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000197a:	7179                	addi	sp,sp,-48
    8000197c:	f406                	sd	ra,40(sp)
    8000197e:	f022                	sd	s0,32(sp)
    80001980:	ec26                	sd	s1,24(sp)
    80001982:	e84a                	sd	s2,16(sp)
    80001984:	e44e                	sd	s3,8(sp)
    80001986:	1800                	addi	s0,sp,48
    80001988:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000198a:	00008497          	auipc	s1,0x8
    8000198e:	af648493          	addi	s1,s1,-1290 # 80009480 <proc>
    80001992:	00019997          	auipc	s3,0x19
    80001996:	6ee98993          	addi	s3,s3,1774 # 8001b080 <tickslock>
    acquire(&p->lock);
    8000199a:	8526                	mv	a0,s1
    8000199c:	00005097          	auipc	ra,0x5
    800019a0:	c8e080e7          	jalr	-882(ra) # 8000662a <acquire>
    if(p->pid == pid){
    800019a4:	3384a783          	lw	a5,824(s1)
    800019a8:	01278d63          	beq	a5,s2,800019c2 <kill+0x48>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800019ac:	8526                	mv	a0,s1
    800019ae:	00005097          	auipc	ra,0x5
    800019b2:	d30080e7          	jalr	-720(ra) # 800066de <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800019b6:	47048493          	addi	s1,s1,1136
    800019ba:	ff3490e3          	bne	s1,s3,8000199a <kill+0x20>
  }
  return -1;
    800019be:	557d                	li	a0,-1
    800019c0:	a839                	j	800019de <kill+0x64>
      p->killed = 1;
    800019c2:	4785                	li	a5,1
    800019c4:	32f4a823          	sw	a5,816(s1)
      if(p->state == SLEEPING){
    800019c8:	3204a703          	lw	a4,800(s1)
    800019cc:	4789                	li	a5,2
    800019ce:	00f70f63          	beq	a4,a5,800019ec <kill+0x72>
      release(&p->lock);
    800019d2:	8526                	mv	a0,s1
    800019d4:	00005097          	auipc	ra,0x5
    800019d8:	d0a080e7          	jalr	-758(ra) # 800066de <release>
      return 0;
    800019dc:	4501                	li	a0,0
}
    800019de:	70a2                	ld	ra,40(sp)
    800019e0:	7402                	ld	s0,32(sp)
    800019e2:	64e2                	ld	s1,24(sp)
    800019e4:	6942                	ld	s2,16(sp)
    800019e6:	69a2                	ld	s3,8(sp)
    800019e8:	6145                	addi	sp,sp,48
    800019ea:	8082                	ret
        p->state = RUNNABLE;
    800019ec:	478d                	li	a5,3
    800019ee:	32f4a023          	sw	a5,800(s1)
    800019f2:	b7c5                	j	800019d2 <kill+0x58>

00000000800019f4 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019f4:	7179                	addi	sp,sp,-48
    800019f6:	f406                	sd	ra,40(sp)
    800019f8:	f022                	sd	s0,32(sp)
    800019fa:	ec26                	sd	s1,24(sp)
    800019fc:	e84a                	sd	s2,16(sp)
    800019fe:	e44e                	sd	s3,8(sp)
    80001a00:	e052                	sd	s4,0(sp)
    80001a02:	1800                	addi	s0,sp,48
    80001a04:	84aa                	mv	s1,a0
    80001a06:	892e                	mv	s2,a1
    80001a08:	89b2                	mv	s3,a2
    80001a0a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a0c:	fffff097          	auipc	ra,0xfffff
    80001a10:	43a080e7          	jalr	1082(ra) # 80000e46 <myproc>
  if(user_dst){
    80001a14:	c095                	beqz	s1,80001a38 <either_copyout+0x44>
    return copyout(p->pagetable, dst, src, len);
    80001a16:	86d2                	mv	a3,s4
    80001a18:	864e                	mv	a2,s3
    80001a1a:	85ca                	mv	a1,s2
    80001a1c:	35853503          	ld	a0,856(a0)
    80001a20:	fffff097          	auipc	ra,0xfffff
    80001a24:	0e8080e7          	jalr	232(ra) # 80000b08 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a28:	70a2                	ld	ra,40(sp)
    80001a2a:	7402                	ld	s0,32(sp)
    80001a2c:	64e2                	ld	s1,24(sp)
    80001a2e:	6942                	ld	s2,16(sp)
    80001a30:	69a2                	ld	s3,8(sp)
    80001a32:	6a02                	ld	s4,0(sp)
    80001a34:	6145                	addi	sp,sp,48
    80001a36:	8082                	ret
    memmove((char *)dst, src, len);
    80001a38:	000a061b          	sext.w	a2,s4
    80001a3c:	85ce                	mv	a1,s3
    80001a3e:	854a                	mv	a0,s2
    80001a40:	ffffe097          	auipc	ra,0xffffe
    80001a44:	796080e7          	jalr	1942(ra) # 800001d6 <memmove>
    return 0;
    80001a48:	8526                	mv	a0,s1
    80001a4a:	bff9                	j	80001a28 <either_copyout+0x34>

0000000080001a4c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a4c:	7179                	addi	sp,sp,-48
    80001a4e:	f406                	sd	ra,40(sp)
    80001a50:	f022                	sd	s0,32(sp)
    80001a52:	ec26                	sd	s1,24(sp)
    80001a54:	e84a                	sd	s2,16(sp)
    80001a56:	e44e                	sd	s3,8(sp)
    80001a58:	e052                	sd	s4,0(sp)
    80001a5a:	1800                	addi	s0,sp,48
    80001a5c:	892a                	mv	s2,a0
    80001a5e:	84ae                	mv	s1,a1
    80001a60:	89b2                	mv	s3,a2
    80001a62:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a64:	fffff097          	auipc	ra,0xfffff
    80001a68:	3e2080e7          	jalr	994(ra) # 80000e46 <myproc>
  if(user_src){
    80001a6c:	c095                	beqz	s1,80001a90 <either_copyin+0x44>
    return copyin(p->pagetable, dst, src, len);
    80001a6e:	86d2                	mv	a3,s4
    80001a70:	864e                	mv	a2,s3
    80001a72:	85ca                	mv	a1,s2
    80001a74:	35853503          	ld	a0,856(a0)
    80001a78:	fffff097          	auipc	ra,0xfffff
    80001a7c:	11c080e7          	jalr	284(ra) # 80000b94 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a80:	70a2                	ld	ra,40(sp)
    80001a82:	7402                	ld	s0,32(sp)
    80001a84:	64e2                	ld	s1,24(sp)
    80001a86:	6942                	ld	s2,16(sp)
    80001a88:	69a2                	ld	s3,8(sp)
    80001a8a:	6a02                	ld	s4,0(sp)
    80001a8c:	6145                	addi	sp,sp,48
    80001a8e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a90:	000a061b          	sext.w	a2,s4
    80001a94:	85ce                	mv	a1,s3
    80001a96:	854a                	mv	a0,s2
    80001a98:	ffffe097          	auipc	ra,0xffffe
    80001a9c:	73e080e7          	jalr	1854(ra) # 800001d6 <memmove>
    return 0;
    80001aa0:	8526                	mv	a0,s1
    80001aa2:	bff9                	j	80001a80 <either_copyin+0x34>

0000000080001aa4 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001aa4:	715d                	addi	sp,sp,-80
    80001aa6:	e486                	sd	ra,72(sp)
    80001aa8:	e0a2                	sd	s0,64(sp)
    80001aaa:	fc26                	sd	s1,56(sp)
    80001aac:	f84a                	sd	s2,48(sp)
    80001aae:	f44e                	sd	s3,40(sp)
    80001ab0:	f052                	sd	s4,32(sp)
    80001ab2:	ec56                	sd	s5,24(sp)
    80001ab4:	e85a                	sd	s6,16(sp)
    80001ab6:	e45e                	sd	s7,8(sp)
    80001ab8:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001aba:	00006517          	auipc	a0,0x6
    80001abe:	58e50513          	addi	a0,a0,1422 # 80008048 <etext+0x48>
    80001ac2:	00004097          	auipc	ra,0x4
    80001ac6:	67a080e7          	jalr	1658(ra) # 8000613c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001aca:	00008497          	auipc	s1,0x8
    80001ace:	e1648493          	addi	s1,s1,-490 # 800098e0 <proc+0x460>
    80001ad2:	0001a917          	auipc	s2,0x1a
    80001ad6:	a0e90913          	addi	s2,s2,-1522 # 8001b4e0 <bcache+0x448>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ada:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001adc:	00006997          	auipc	s3,0x6
    80001ae0:	72498993          	addi	s3,s3,1828 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001ae4:	00006a97          	auipc	s5,0x6
    80001ae8:	724a8a93          	addi	s5,s5,1828 # 80008208 <etext+0x208>
    printf("\n");
    80001aec:	00006a17          	auipc	s4,0x6
    80001af0:	55ca0a13          	addi	s4,s4,1372 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001af4:	00006b97          	auipc	s7,0x6
    80001af8:	74cb8b93          	addi	s7,s7,1868 # 80008240 <states.0>
    80001afc:	a00d                	j	80001b1e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001afe:	ed86a583          	lw	a1,-296(a3)
    80001b02:	8556                	mv	a0,s5
    80001b04:	00004097          	auipc	ra,0x4
    80001b08:	638080e7          	jalr	1592(ra) # 8000613c <printf>
    printf("\n");
    80001b0c:	8552                	mv	a0,s4
    80001b0e:	00004097          	auipc	ra,0x4
    80001b12:	62e080e7          	jalr	1582(ra) # 8000613c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b16:	47048493          	addi	s1,s1,1136
    80001b1a:	03248263          	beq	s1,s2,80001b3e <procdump+0x9a>
    if(p->state == UNUSED)
    80001b1e:	86a6                	mv	a3,s1
    80001b20:	ec04a783          	lw	a5,-320(s1)
    80001b24:	dbed                	beqz	a5,80001b16 <procdump+0x72>
      state = "???";
    80001b26:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b28:	fcfb6be3          	bltu	s6,a5,80001afe <procdump+0x5a>
    80001b2c:	02079713          	slli	a4,a5,0x20
    80001b30:	01d75793          	srli	a5,a4,0x1d
    80001b34:	97de                	add	a5,a5,s7
    80001b36:	6390                	ld	a2,0(a5)
    80001b38:	f279                	bnez	a2,80001afe <procdump+0x5a>
      state = "???";
    80001b3a:	864e                	mv	a2,s3
    80001b3c:	b7c9                	j	80001afe <procdump+0x5a>
  }
}
    80001b3e:	60a6                	ld	ra,72(sp)
    80001b40:	6406                	ld	s0,64(sp)
    80001b42:	74e2                	ld	s1,56(sp)
    80001b44:	7942                	ld	s2,48(sp)
    80001b46:	79a2                	ld	s3,40(sp)
    80001b48:	7a02                	ld	s4,32(sp)
    80001b4a:	6ae2                	ld	s5,24(sp)
    80001b4c:	6b42                	ld	s6,16(sp)
    80001b4e:	6ba2                	ld	s7,8(sp)
    80001b50:	6161                	addi	sp,sp,80
    80001b52:	8082                	ret

0000000080001b54 <swtch>:
    80001b54:	00153023          	sd	ra,0(a0)
    80001b58:	00253423          	sd	sp,8(a0)
    80001b5c:	e900                	sd	s0,16(a0)
    80001b5e:	ed04                	sd	s1,24(a0)
    80001b60:	03253023          	sd	s2,32(a0)
    80001b64:	03353423          	sd	s3,40(a0)
    80001b68:	03453823          	sd	s4,48(a0)
    80001b6c:	03553c23          	sd	s5,56(a0)
    80001b70:	05653023          	sd	s6,64(a0)
    80001b74:	05753423          	sd	s7,72(a0)
    80001b78:	05853823          	sd	s8,80(a0)
    80001b7c:	05953c23          	sd	s9,88(a0)
    80001b80:	07a53023          	sd	s10,96(a0)
    80001b84:	07b53423          	sd	s11,104(a0)
    80001b88:	0005b083          	ld	ra,0(a1)
    80001b8c:	0085b103          	ld	sp,8(a1)
    80001b90:	6980                	ld	s0,16(a1)
    80001b92:	6d84                	ld	s1,24(a1)
    80001b94:	0205b903          	ld	s2,32(a1)
    80001b98:	0285b983          	ld	s3,40(a1)
    80001b9c:	0305ba03          	ld	s4,48(a1)
    80001ba0:	0385ba83          	ld	s5,56(a1)
    80001ba4:	0405bb03          	ld	s6,64(a1)
    80001ba8:	0485bb83          	ld	s7,72(a1)
    80001bac:	0505bc03          	ld	s8,80(a1)
    80001bb0:	0585bc83          	ld	s9,88(a1)
    80001bb4:	0605bd03          	ld	s10,96(a1)
    80001bb8:	0685bd83          	ld	s11,104(a1)
    80001bbc:	8082                	ret

0000000080001bbe <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001bbe:	1141                	addi	sp,sp,-16
    80001bc0:	e406                	sd	ra,8(sp)
    80001bc2:	e022                	sd	s0,0(sp)
    80001bc4:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001bc6:	00006597          	auipc	a1,0x6
    80001bca:	6aa58593          	addi	a1,a1,1706 # 80008270 <states.0+0x30>
    80001bce:	00019517          	auipc	a0,0x19
    80001bd2:	4b250513          	addi	a0,a0,1202 # 8001b080 <tickslock>
    80001bd6:	00005097          	auipc	ra,0x5
    80001bda:	9c4080e7          	jalr	-1596(ra) # 8000659a <initlock>
}
    80001bde:	60a2                	ld	ra,8(sp)
    80001be0:	6402                	ld	s0,0(sp)
    80001be2:	0141                	addi	sp,sp,16
    80001be4:	8082                	ret

0000000080001be6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001be6:	1141                	addi	sp,sp,-16
    80001be8:	e422                	sd	s0,8(sp)
    80001bea:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bec:	00004797          	auipc	a5,0x4
    80001bf0:	96478793          	addi	a5,a5,-1692 # 80005550 <kernelvec>
    80001bf4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bf8:	6422                	ld	s0,8(sp)
    80001bfa:	0141                	addi	sp,sp,16
    80001bfc:	8082                	ret

0000000080001bfe <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001bfe:	1141                	addi	sp,sp,-16
    80001c00:	e406                	sd	ra,8(sp)
    80001c02:	e022                	sd	s0,0(sp)
    80001c04:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c06:	fffff097          	auipc	ra,0xfffff
    80001c0a:	240080e7          	jalr	576(ra) # 80000e46 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c0e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c12:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c14:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c18:	00005697          	auipc	a3,0x5
    80001c1c:	3e868693          	addi	a3,a3,1000 # 80007000 <_trampoline>
    80001c20:	00005717          	auipc	a4,0x5
    80001c24:	3e070713          	addi	a4,a4,992 # 80007000 <_trampoline>
    80001c28:	8f15                	sub	a4,a4,a3
    80001c2a:	040007b7          	lui	a5,0x4000
    80001c2e:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c30:	07b2                	slli	a5,a5,0xc
    80001c32:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c34:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c38:	36053703          	ld	a4,864(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c3c:	18002673          	csrr	a2,satp
    80001c40:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c42:	36053603          	ld	a2,864(a0)
    80001c46:	34853703          	ld	a4,840(a0)
    80001c4a:	6585                	lui	a1,0x1
    80001c4c:	972e                	add	a4,a4,a1
    80001c4e:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c50:	36053703          	ld	a4,864(a0)
    80001c54:	00000617          	auipc	a2,0x0
    80001c58:	05660613          	addi	a2,a2,86 # 80001caa <usertrap>
    80001c5c:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c5e:	36053703          	ld	a4,864(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c62:	8612                	mv	a2,tp
    80001c64:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c66:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c6a:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c6e:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c72:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c76:	36053703          	ld	a4,864(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c7a:	6f18                	ld	a4,24(a4)
    80001c7c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c80:	35853583          	ld	a1,856(a0)
    80001c84:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c86:	00005717          	auipc	a4,0x5
    80001c8a:	40a70713          	addi	a4,a4,1034 # 80007090 <userret>
    80001c8e:	8f15                	sub	a4,a4,a3
    80001c90:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001c92:	577d                	li	a4,-1
    80001c94:	177e                	slli	a4,a4,0x3f
    80001c96:	8dd9                	or	a1,a1,a4
    80001c98:	02000537          	lui	a0,0x2000
    80001c9c:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001c9e:	0536                	slli	a0,a0,0xd
    80001ca0:	9782                	jalr	a5
}
    80001ca2:	60a2                	ld	ra,8(sp)
    80001ca4:	6402                	ld	s0,0(sp)
    80001ca6:	0141                	addi	sp,sp,16
    80001ca8:	8082                	ret

0000000080001caa <usertrap>:
{
    80001caa:	7139                	addi	sp,sp,-64
    80001cac:	fc06                	sd	ra,56(sp)
    80001cae:	f822                	sd	s0,48(sp)
    80001cb0:	f426                	sd	s1,40(sp)
    80001cb2:	f04a                	sd	s2,32(sp)
    80001cb4:	ec4e                	sd	s3,24(sp)
    80001cb6:	e852                	sd	s4,16(sp)
    80001cb8:	e456                	sd	s5,8(sp)
    80001cba:	e05a                	sd	s6,0(sp)
    80001cbc:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cbe:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cc2:	1007f793          	andi	a5,a5,256
    80001cc6:	e3b9                	bnez	a5,80001d0c <usertrap+0x62>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cc8:	00004797          	auipc	a5,0x4
    80001ccc:	88878793          	addi	a5,a5,-1912 # 80005550 <kernelvec>
    80001cd0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cd4:	fffff097          	auipc	ra,0xfffff
    80001cd8:	172080e7          	jalr	370(ra) # 80000e46 <myproc>
    80001cdc:	89aa                	mv	s3,a0
  p->trapframe->epc = r_sepc();
    80001cde:	36053783          	ld	a5,864(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ce2:	14102773          	csrr	a4,sepc
    80001ce6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ce8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cec:	47a1                	li	a5,8
    80001cee:	02f70763          	beq	a4,a5,80001d1c <usertrap+0x72>
    80001cf2:	14202773          	csrr	a4,scause
  } else if( r_scause() == 0xd )
    80001cf6:	47b5                	li	a5,13
    80001cf8:	12f71e63          	bne	a4,a5,80001e34 <usertrap+0x18a>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001cfc:	14302973          	csrr	s2,stval
     for( int i=0 ; i<VMA_MAX ; i++ )
    80001d00:	01850793          	addi	a5,a0,24
    80001d04:	4481                	li	s1,0
       if( p->vma[i].addr <= addr && addr < p->vma[i].addr + p->vma[i].len && p->vma[i].valid == 1 )
    80001d06:	4505                	li	a0,1
     for( int i=0 ; i<VMA_MAX ; i++ )
    80001d08:	45c1                	li	a1,16
    80001d0a:	a885                	j	80001d7a <usertrap+0xd0>
    panic("usertrap: not from user mode");
    80001d0c:	00006517          	auipc	a0,0x6
    80001d10:	56c50513          	addi	a0,a0,1388 # 80008278 <states.0+0x38>
    80001d14:	00004097          	auipc	ra,0x4
    80001d18:	3de080e7          	jalr	990(ra) # 800060f2 <panic>
    if(p->killed)
    80001d1c:	33052783          	lw	a5,816(a0)
    80001d20:	e3b1                	bnez	a5,80001d64 <usertrap+0xba>
    p->trapframe->epc += 4;
    80001d22:	3609b703          	ld	a4,864(s3)
    80001d26:	6f1c                	ld	a5,24(a4)
    80001d28:	0791                	addi	a5,a5,4
    80001d2a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d2c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d30:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d34:	10079073          	csrw	sstatus,a5
    syscall();
    80001d38:	00000097          	auipc	ra,0x0
    80001d3c:	4ae080e7          	jalr	1198(ra) # 800021e6 <syscall>
  if(p->killed)
    80001d40:	3309a783          	lw	a5,816(s3)
    80001d44:	12079363          	bnez	a5,80001e6a <usertrap+0x1c0>
  usertrapret();
    80001d48:	00000097          	auipc	ra,0x0
    80001d4c:	eb6080e7          	jalr	-330(ra) # 80001bfe <usertrapret>
}
    80001d50:	70e2                	ld	ra,56(sp)
    80001d52:	7442                	ld	s0,48(sp)
    80001d54:	74a2                	ld	s1,40(sp)
    80001d56:	7902                	ld	s2,32(sp)
    80001d58:	69e2                	ld	s3,24(sp)
    80001d5a:	6a42                	ld	s4,16(sp)
    80001d5c:	6aa2                	ld	s5,8(sp)
    80001d5e:	6b02                	ld	s6,0(sp)
    80001d60:	6121                	addi	sp,sp,64
    80001d62:	8082                	ret
      exit(-1);
    80001d64:	557d                	li	a0,-1
    80001d66:	00000097          	auipc	ra,0x0
    80001d6a:	aa2080e7          	jalr	-1374(ra) # 80001808 <exit>
    80001d6e:	bf55                	j	80001d22 <usertrap+0x78>
     for( int i=0 ; i<VMA_MAX ; i++ )
    80001d70:	2485                	addiw	s1,s1,1
    80001d72:	03078793          	addi	a5,a5,48
    80001d76:	10b48063          	beq	s1,a1,80001e76 <usertrap+0x1cc>
       if( p->vma[i].addr <= addr && addr < p->vma[i].addr + p->vma[i].len && p->vma[i].valid == 1 )
    80001d7a:	6798                	ld	a4,8(a5)
    80001d7c:	fee96ae3          	bltu	s2,a4,80001d70 <usertrap+0xc6>
    80001d80:	4b94                	lw	a3,16(a5)
    80001d82:	9736                	add	a4,a4,a3
    80001d84:	fee976e3          	bgeu	s2,a4,80001d70 <usertrap+0xc6>
    80001d88:	4398                	lw	a4,0(a5)
    80001d8a:	fea713e3          	bne	a4,a0,80001d70 <usertrap+0xc6>
       uint64 mem = (uint64)kalloc();
    80001d8e:	ffffe097          	auipc	ra,0xffffe
    80001d92:	38c080e7          	jalr	908(ra) # 8000011a <kalloc>
    80001d96:	8b2a                	mv	s6,a0
       memset( (void*)mem , 0 , PGSIZE );
    80001d98:	6605                	lui	a2,0x1
    80001d9a:	4581                	li	a1,0
    80001d9c:	ffffe097          	auipc	ra,0xffffe
    80001da0:	3de080e7          	jalr	990(ra) # 8000017a <memset>
       if( -1 ==  mappages( p->pagetable , addr,  PGSIZE , mem , PTE_U | PTE_V | ( vp->prot << 1 ) ) )
    80001da4:	00149793          	slli	a5,s1,0x1
    80001da8:	97a6                	add	a5,a5,s1
    80001daa:	0792                	slli	a5,a5,0x4
    80001dac:	97ce                	add	a5,a5,s3
    80001dae:	57d8                	lw	a4,44(a5)
    80001db0:	0017171b          	slliw	a4,a4,0x1
    80001db4:	01176713          	ori	a4,a4,17
    80001db8:	2701                	sext.w	a4,a4
    80001dba:	86da                	mv	a3,s6
    80001dbc:	6605                	lui	a2,0x1
    80001dbe:	85ca                	mv	a1,s2
    80001dc0:	3589b503          	ld	a0,856(s3)
    80001dc4:	ffffe097          	auipc	ra,0xffffe
    80001dc8:	77e080e7          	jalr	1918(ra) # 80000542 <mappages>
    80001dcc:	57fd                	li	a5,-1
    80001dce:	04f50b63          	beq	a0,a5,80001e24 <usertrap+0x17a>
       vp->mapcnt += PGSIZE; //maintain the mapcnt
    80001dd2:	00149a93          	slli	s5,s1,0x1
    80001dd6:	009a8a33          	add	s4,s5,s1
    80001dda:	0a12                	slli	s4,s4,0x4
    80001ddc:	9a4e                	add	s4,s4,s3
    80001dde:	040a3783          	ld	a5,64(s4)
    80001de2:	6705                	lui	a4,0x1
    80001de4:	97ba                	add	a5,a5,a4
    80001de6:	04fa3023          	sd	a5,64(s4)
       ilock( vp->f->ip );
    80001dea:	038a3783          	ld	a5,56(s4)
    80001dee:	6f88                	ld	a0,24(a5)
    80001df0:	00001097          	auipc	ra,0x1
    80001df4:	efe080e7          	jalr	-258(ra) # 80002cee <ilock>
       readi( vp->f->ip , 0 , mem , addr-vp->addr , PGSIZE); //copy a page of the file from the disk
    80001df8:	020a3683          	ld	a3,32(s4)
    80001dfc:	038a3783          	ld	a5,56(s4)
    80001e00:	6705                	lui	a4,0x1
    80001e02:	40d906bb          	subw	a3,s2,a3
    80001e06:	865a                	mv	a2,s6
    80001e08:	4581                	li	a1,0
    80001e0a:	6f88                	ld	a0,24(a5)
    80001e0c:	00001097          	auipc	ra,0x1
    80001e10:	196080e7          	jalr	406(ra) # 80002fa2 <readi>
       iunlock( vp->f->ip );
    80001e14:	038a3783          	ld	a5,56(s4)
    80001e18:	6f88                	ld	a0,24(a5)
    80001e1a:	00001097          	auipc	ra,0x1
    80001e1e:	f96080e7          	jalr	-106(ra) # 80002db0 <iunlock>
    80001e22:	bf39                	j	80001d40 <usertrap+0x96>
         panic("pagefault map error");
    80001e24:	00006517          	auipc	a0,0x6
    80001e28:	47450513          	addi	a0,a0,1140 # 80008298 <states.0+0x58>
    80001e2c:	00004097          	auipc	ra,0x4
    80001e30:	2c6080e7          	jalr	710(ra) # 800060f2 <panic>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e34:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e38:	33852603          	lw	a2,824(a0)
    80001e3c:	00006517          	auipc	a0,0x6
    80001e40:	47450513          	addi	a0,a0,1140 # 800082b0 <states.0+0x70>
    80001e44:	00004097          	auipc	ra,0x4
    80001e48:	2f8080e7          	jalr	760(ra) # 8000613c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e4c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e50:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e54:	00006517          	auipc	a0,0x6
    80001e58:	48c50513          	addi	a0,a0,1164 # 800082e0 <states.0+0xa0>
    80001e5c:	00004097          	auipc	ra,0x4
    80001e60:	2e0080e7          	jalr	736(ra) # 8000613c <printf>
    p->killed = 1;
    80001e64:	4785                	li	a5,1
    80001e66:	32f9a823          	sw	a5,816(s3)
    exit(-1);
    80001e6a:	557d                	li	a0,-1
    80001e6c:	00000097          	auipc	ra,0x0
    80001e70:	99c080e7          	jalr	-1636(ra) # 80001808 <exit>
    80001e74:	bdd1                	j	80001d48 <usertrap+0x9e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e76:	142025f3          	csrr	a1,scause
       printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e7a:	3389a603          	lw	a2,824(s3)
    80001e7e:	00006517          	auipc	a0,0x6
    80001e82:	43250513          	addi	a0,a0,1074 # 800082b0 <states.0+0x70>
    80001e86:	00004097          	auipc	ra,0x4
    80001e8a:	2b6080e7          	jalr	694(ra) # 8000613c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e8e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e92:	14302673          	csrr	a2,stval
       printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e96:	00006517          	auipc	a0,0x6
    80001e9a:	44a50513          	addi	a0,a0,1098 # 800082e0 <states.0+0xa0>
    80001e9e:	00004097          	auipc	ra,0x4
    80001ea2:	29e080e7          	jalr	670(ra) # 8000613c <printf>
       p->killed = 1;
    80001ea6:	bf7d                	j	80001e64 <usertrap+0x1ba>

0000000080001ea8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001ea8:	1101                	addi	sp,sp,-32
    80001eaa:	ec06                	sd	ra,24(sp)
    80001eac:	e822                	sd	s0,16(sp)
    80001eae:	e426                	sd	s1,8(sp)
    80001eb0:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001eb2:	00019497          	auipc	s1,0x19
    80001eb6:	1ce48493          	addi	s1,s1,462 # 8001b080 <tickslock>
    80001eba:	8526                	mv	a0,s1
    80001ebc:	00004097          	auipc	ra,0x4
    80001ec0:	76e080e7          	jalr	1902(ra) # 8000662a <acquire>
  ticks++;
    80001ec4:	00007517          	auipc	a0,0x7
    80001ec8:	15450513          	addi	a0,a0,340 # 80009018 <ticks>
    80001ecc:	411c                	lw	a5,0(a0)
    80001ece:	2785                	addiw	a5,a5,1
    80001ed0:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001ed2:	00000097          	auipc	ra,0x0
    80001ed6:	85e080e7          	jalr	-1954(ra) # 80001730 <wakeup>
  release(&tickslock);
    80001eda:	8526                	mv	a0,s1
    80001edc:	00005097          	auipc	ra,0x5
    80001ee0:	802080e7          	jalr	-2046(ra) # 800066de <release>
}
    80001ee4:	60e2                	ld	ra,24(sp)
    80001ee6:	6442                	ld	s0,16(sp)
    80001ee8:	64a2                	ld	s1,8(sp)
    80001eea:	6105                	addi	sp,sp,32
    80001eec:	8082                	ret

0000000080001eee <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001eee:	1101                	addi	sp,sp,-32
    80001ef0:	ec06                	sd	ra,24(sp)
    80001ef2:	e822                	sd	s0,16(sp)
    80001ef4:	e426                	sd	s1,8(sp)
    80001ef6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ef8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001efc:	00074d63          	bltz	a4,80001f16 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001f00:	57fd                	li	a5,-1
    80001f02:	17fe                	slli	a5,a5,0x3f
    80001f04:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001f06:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001f08:	06f70363          	beq	a4,a5,80001f6e <devintr+0x80>
  }
}
    80001f0c:	60e2                	ld	ra,24(sp)
    80001f0e:	6442                	ld	s0,16(sp)
    80001f10:	64a2                	ld	s1,8(sp)
    80001f12:	6105                	addi	sp,sp,32
    80001f14:	8082                	ret
     (scause & 0xff) == 9){
    80001f16:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001f1a:	46a5                	li	a3,9
    80001f1c:	fed792e3          	bne	a5,a3,80001f00 <devintr+0x12>
    int irq = plic_claim();
    80001f20:	00003097          	auipc	ra,0x3
    80001f24:	738080e7          	jalr	1848(ra) # 80005658 <plic_claim>
    80001f28:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001f2a:	47a9                	li	a5,10
    80001f2c:	02f50763          	beq	a0,a5,80001f5a <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001f30:	4785                	li	a5,1
    80001f32:	02f50963          	beq	a0,a5,80001f64 <devintr+0x76>
    return 1;
    80001f36:	4505                	li	a0,1
    } else if(irq){
    80001f38:	d8f1                	beqz	s1,80001f0c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001f3a:	85a6                	mv	a1,s1
    80001f3c:	00006517          	auipc	a0,0x6
    80001f40:	3c450513          	addi	a0,a0,964 # 80008300 <states.0+0xc0>
    80001f44:	00004097          	auipc	ra,0x4
    80001f48:	1f8080e7          	jalr	504(ra) # 8000613c <printf>
      plic_complete(irq);
    80001f4c:	8526                	mv	a0,s1
    80001f4e:	00003097          	auipc	ra,0x3
    80001f52:	72e080e7          	jalr	1838(ra) # 8000567c <plic_complete>
    return 1;
    80001f56:	4505                	li	a0,1
    80001f58:	bf55                	j	80001f0c <devintr+0x1e>
      uartintr();
    80001f5a:	00004097          	auipc	ra,0x4
    80001f5e:	5f0080e7          	jalr	1520(ra) # 8000654a <uartintr>
    80001f62:	b7ed                	j	80001f4c <devintr+0x5e>
      virtio_disk_intr();
    80001f64:	00004097          	auipc	ra,0x4
    80001f68:	ba4080e7          	jalr	-1116(ra) # 80005b08 <virtio_disk_intr>
    80001f6c:	b7c5                	j	80001f4c <devintr+0x5e>
    if(cpuid() == 0){
    80001f6e:	fffff097          	auipc	ra,0xfffff
    80001f72:	eac080e7          	jalr	-340(ra) # 80000e1a <cpuid>
    80001f76:	c901                	beqz	a0,80001f86 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001f78:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001f7c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001f7e:	14479073          	csrw	sip,a5
    return 2;
    80001f82:	4509                	li	a0,2
    80001f84:	b761                	j	80001f0c <devintr+0x1e>
      clockintr();
    80001f86:	00000097          	auipc	ra,0x0
    80001f8a:	f22080e7          	jalr	-222(ra) # 80001ea8 <clockintr>
    80001f8e:	b7ed                	j	80001f78 <devintr+0x8a>

0000000080001f90 <kerneltrap>:
{
    80001f90:	7179                	addi	sp,sp,-48
    80001f92:	f406                	sd	ra,40(sp)
    80001f94:	f022                	sd	s0,32(sp)
    80001f96:	ec26                	sd	s1,24(sp)
    80001f98:	e84a                	sd	s2,16(sp)
    80001f9a:	e44e                	sd	s3,8(sp)
    80001f9c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f9e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fa2:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fa6:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001faa:	1004f793          	andi	a5,s1,256
    80001fae:	cb85                	beqz	a5,80001fde <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fb0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001fb4:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001fb6:	ef85                	bnez	a5,80001fee <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001fb8:	00000097          	auipc	ra,0x0
    80001fbc:	f36080e7          	jalr	-202(ra) # 80001eee <devintr>
    80001fc0:	cd1d                	beqz	a0,80001ffe <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fc2:	4789                	li	a5,2
    80001fc4:	06f50a63          	beq	a0,a5,80002038 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001fc8:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fcc:	10049073          	csrw	sstatus,s1
}
    80001fd0:	70a2                	ld	ra,40(sp)
    80001fd2:	7402                	ld	s0,32(sp)
    80001fd4:	64e2                	ld	s1,24(sp)
    80001fd6:	6942                	ld	s2,16(sp)
    80001fd8:	69a2                	ld	s3,8(sp)
    80001fda:	6145                	addi	sp,sp,48
    80001fdc:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001fde:	00006517          	auipc	a0,0x6
    80001fe2:	34250513          	addi	a0,a0,834 # 80008320 <states.0+0xe0>
    80001fe6:	00004097          	auipc	ra,0x4
    80001fea:	10c080e7          	jalr	268(ra) # 800060f2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001fee:	00006517          	auipc	a0,0x6
    80001ff2:	35a50513          	addi	a0,a0,858 # 80008348 <states.0+0x108>
    80001ff6:	00004097          	auipc	ra,0x4
    80001ffa:	0fc080e7          	jalr	252(ra) # 800060f2 <panic>
    printf("scause %p\n", scause);
    80001ffe:	85ce                	mv	a1,s3
    80002000:	00006517          	auipc	a0,0x6
    80002004:	36850513          	addi	a0,a0,872 # 80008368 <states.0+0x128>
    80002008:	00004097          	auipc	ra,0x4
    8000200c:	134080e7          	jalr	308(ra) # 8000613c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002010:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002014:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002018:	00006517          	auipc	a0,0x6
    8000201c:	36050513          	addi	a0,a0,864 # 80008378 <states.0+0x138>
    80002020:	00004097          	auipc	ra,0x4
    80002024:	11c080e7          	jalr	284(ra) # 8000613c <printf>
    panic("kerneltrap");
    80002028:	00006517          	auipc	a0,0x6
    8000202c:	36850513          	addi	a0,a0,872 # 80008390 <states.0+0x150>
    80002030:	00004097          	auipc	ra,0x4
    80002034:	0c2080e7          	jalr	194(ra) # 800060f2 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002038:	fffff097          	auipc	ra,0xfffff
    8000203c:	e0e080e7          	jalr	-498(ra) # 80000e46 <myproc>
    80002040:	d541                	beqz	a0,80001fc8 <kerneltrap+0x38>
    80002042:	fffff097          	auipc	ra,0xfffff
    80002046:	e04080e7          	jalr	-508(ra) # 80000e46 <myproc>
    8000204a:	32052703          	lw	a4,800(a0)
    8000204e:	4791                	li	a5,4
    80002050:	f6f71ce3          	bne	a4,a5,80001fc8 <kerneltrap+0x38>
    yield();
    80002054:	fffff097          	auipc	ra,0xfffff
    80002058:	50c080e7          	jalr	1292(ra) # 80001560 <yield>
    8000205c:	b7b5                	j	80001fc8 <kerneltrap+0x38>

000000008000205e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000205e:	1101                	addi	sp,sp,-32
    80002060:	ec06                	sd	ra,24(sp)
    80002062:	e822                	sd	s0,16(sp)
    80002064:	e426                	sd	s1,8(sp)
    80002066:	1000                	addi	s0,sp,32
    80002068:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000206a:	fffff097          	auipc	ra,0xfffff
    8000206e:	ddc080e7          	jalr	-548(ra) # 80000e46 <myproc>
  switch (n) {
    80002072:	4795                	li	a5,5
    80002074:	0497e763          	bltu	a5,s1,800020c2 <argraw+0x64>
    80002078:	048a                	slli	s1,s1,0x2
    8000207a:	00006717          	auipc	a4,0x6
    8000207e:	34e70713          	addi	a4,a4,846 # 800083c8 <states.0+0x188>
    80002082:	94ba                	add	s1,s1,a4
    80002084:	409c                	lw	a5,0(s1)
    80002086:	97ba                	add	a5,a5,a4
    80002088:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000208a:	36053783          	ld	a5,864(a0)
    8000208e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002090:	60e2                	ld	ra,24(sp)
    80002092:	6442                	ld	s0,16(sp)
    80002094:	64a2                	ld	s1,8(sp)
    80002096:	6105                	addi	sp,sp,32
    80002098:	8082                	ret
    return p->trapframe->a1;
    8000209a:	36053783          	ld	a5,864(a0)
    8000209e:	7fa8                	ld	a0,120(a5)
    800020a0:	bfc5                	j	80002090 <argraw+0x32>
    return p->trapframe->a2;
    800020a2:	36053783          	ld	a5,864(a0)
    800020a6:	63c8                	ld	a0,128(a5)
    800020a8:	b7e5                	j	80002090 <argraw+0x32>
    return p->trapframe->a3;
    800020aa:	36053783          	ld	a5,864(a0)
    800020ae:	67c8                	ld	a0,136(a5)
    800020b0:	b7c5                	j	80002090 <argraw+0x32>
    return p->trapframe->a4;
    800020b2:	36053783          	ld	a5,864(a0)
    800020b6:	6bc8                	ld	a0,144(a5)
    800020b8:	bfe1                	j	80002090 <argraw+0x32>
    return p->trapframe->a5;
    800020ba:	36053783          	ld	a5,864(a0)
    800020be:	6fc8                	ld	a0,152(a5)
    800020c0:	bfc1                	j	80002090 <argraw+0x32>
  panic("argraw");
    800020c2:	00006517          	auipc	a0,0x6
    800020c6:	2de50513          	addi	a0,a0,734 # 800083a0 <states.0+0x160>
    800020ca:	00004097          	auipc	ra,0x4
    800020ce:	028080e7          	jalr	40(ra) # 800060f2 <panic>

00000000800020d2 <fetchaddr>:
{
    800020d2:	1101                	addi	sp,sp,-32
    800020d4:	ec06                	sd	ra,24(sp)
    800020d6:	e822                	sd	s0,16(sp)
    800020d8:	e426                	sd	s1,8(sp)
    800020da:	e04a                	sd	s2,0(sp)
    800020dc:	1000                	addi	s0,sp,32
    800020de:	84aa                	mv	s1,a0
    800020e0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020e2:	fffff097          	auipc	ra,0xfffff
    800020e6:	d64080e7          	jalr	-668(ra) # 80000e46 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800020ea:	35053783          	ld	a5,848(a0)
    800020ee:	02f4f963          	bgeu	s1,a5,80002120 <fetchaddr+0x4e>
    800020f2:	00848713          	addi	a4,s1,8
    800020f6:	02e7e763          	bltu	a5,a4,80002124 <fetchaddr+0x52>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800020fa:	46a1                	li	a3,8
    800020fc:	8626                	mv	a2,s1
    800020fe:	85ca                	mv	a1,s2
    80002100:	35853503          	ld	a0,856(a0)
    80002104:	fffff097          	auipc	ra,0xfffff
    80002108:	a90080e7          	jalr	-1392(ra) # 80000b94 <copyin>
    8000210c:	00a03533          	snez	a0,a0
    80002110:	40a00533          	neg	a0,a0
}
    80002114:	60e2                	ld	ra,24(sp)
    80002116:	6442                	ld	s0,16(sp)
    80002118:	64a2                	ld	s1,8(sp)
    8000211a:	6902                	ld	s2,0(sp)
    8000211c:	6105                	addi	sp,sp,32
    8000211e:	8082                	ret
    return -1;
    80002120:	557d                	li	a0,-1
    80002122:	bfcd                	j	80002114 <fetchaddr+0x42>
    80002124:	557d                	li	a0,-1
    80002126:	b7fd                	j	80002114 <fetchaddr+0x42>

0000000080002128 <fetchstr>:
{
    80002128:	7179                	addi	sp,sp,-48
    8000212a:	f406                	sd	ra,40(sp)
    8000212c:	f022                	sd	s0,32(sp)
    8000212e:	ec26                	sd	s1,24(sp)
    80002130:	e84a                	sd	s2,16(sp)
    80002132:	e44e                	sd	s3,8(sp)
    80002134:	1800                	addi	s0,sp,48
    80002136:	892a                	mv	s2,a0
    80002138:	84ae                	mv	s1,a1
    8000213a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000213c:	fffff097          	auipc	ra,0xfffff
    80002140:	d0a080e7          	jalr	-758(ra) # 80000e46 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002144:	86ce                	mv	a3,s3
    80002146:	864a                	mv	a2,s2
    80002148:	85a6                	mv	a1,s1
    8000214a:	35853503          	ld	a0,856(a0)
    8000214e:	fffff097          	auipc	ra,0xfffff
    80002152:	ad4080e7          	jalr	-1324(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80002156:	00054763          	bltz	a0,80002164 <fetchstr+0x3c>
  return strlen(buf);
    8000215a:	8526                	mv	a0,s1
    8000215c:	ffffe097          	auipc	ra,0xffffe
    80002160:	19a080e7          	jalr	410(ra) # 800002f6 <strlen>
}
    80002164:	70a2                	ld	ra,40(sp)
    80002166:	7402                	ld	s0,32(sp)
    80002168:	64e2                	ld	s1,24(sp)
    8000216a:	6942                	ld	s2,16(sp)
    8000216c:	69a2                	ld	s3,8(sp)
    8000216e:	6145                	addi	sp,sp,48
    80002170:	8082                	ret

0000000080002172 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002172:	1101                	addi	sp,sp,-32
    80002174:	ec06                	sd	ra,24(sp)
    80002176:	e822                	sd	s0,16(sp)
    80002178:	e426                	sd	s1,8(sp)
    8000217a:	1000                	addi	s0,sp,32
    8000217c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000217e:	00000097          	auipc	ra,0x0
    80002182:	ee0080e7          	jalr	-288(ra) # 8000205e <argraw>
    80002186:	c088                	sw	a0,0(s1)
  return 0;
}
    80002188:	4501                	li	a0,0
    8000218a:	60e2                	ld	ra,24(sp)
    8000218c:	6442                	ld	s0,16(sp)
    8000218e:	64a2                	ld	s1,8(sp)
    80002190:	6105                	addi	sp,sp,32
    80002192:	8082                	ret

0000000080002194 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002194:	1101                	addi	sp,sp,-32
    80002196:	ec06                	sd	ra,24(sp)
    80002198:	e822                	sd	s0,16(sp)
    8000219a:	e426                	sd	s1,8(sp)
    8000219c:	1000                	addi	s0,sp,32
    8000219e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021a0:	00000097          	auipc	ra,0x0
    800021a4:	ebe080e7          	jalr	-322(ra) # 8000205e <argraw>
    800021a8:	e088                	sd	a0,0(s1)
  return 0;
}
    800021aa:	4501                	li	a0,0
    800021ac:	60e2                	ld	ra,24(sp)
    800021ae:	6442                	ld	s0,16(sp)
    800021b0:	64a2                	ld	s1,8(sp)
    800021b2:	6105                	addi	sp,sp,32
    800021b4:	8082                	ret

00000000800021b6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800021b6:	1101                	addi	sp,sp,-32
    800021b8:	ec06                	sd	ra,24(sp)
    800021ba:	e822                	sd	s0,16(sp)
    800021bc:	e426                	sd	s1,8(sp)
    800021be:	e04a                	sd	s2,0(sp)
    800021c0:	1000                	addi	s0,sp,32
    800021c2:	84ae                	mv	s1,a1
    800021c4:	8932                	mv	s2,a2
  *ip = argraw(n);
    800021c6:	00000097          	auipc	ra,0x0
    800021ca:	e98080e7          	jalr	-360(ra) # 8000205e <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800021ce:	864a                	mv	a2,s2
    800021d0:	85a6                	mv	a1,s1
    800021d2:	00000097          	auipc	ra,0x0
    800021d6:	f56080e7          	jalr	-170(ra) # 80002128 <fetchstr>
}
    800021da:	60e2                	ld	ra,24(sp)
    800021dc:	6442                	ld	s0,16(sp)
    800021de:	64a2                	ld	s1,8(sp)
    800021e0:	6902                	ld	s2,0(sp)
    800021e2:	6105                	addi	sp,sp,32
    800021e4:	8082                	ret

00000000800021e6 <syscall>:
[SYS_munmap]  sys_munmap,
};

void
syscall(void)
{
    800021e6:	1101                	addi	sp,sp,-32
    800021e8:	ec06                	sd	ra,24(sp)
    800021ea:	e822                	sd	s0,16(sp)
    800021ec:	e426                	sd	s1,8(sp)
    800021ee:	e04a                	sd	s2,0(sp)
    800021f0:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800021f2:	fffff097          	auipc	ra,0xfffff
    800021f6:	c54080e7          	jalr	-940(ra) # 80000e46 <myproc>
    800021fa:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800021fc:	36053903          	ld	s2,864(a0)
    80002200:	0a893783          	ld	a5,168(s2)
    80002204:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002208:	37fd                	addiw	a5,a5,-1
    8000220a:	4759                	li	a4,22
    8000220c:	00f76f63          	bltu	a4,a5,8000222a <syscall+0x44>
    80002210:	00369713          	slli	a4,a3,0x3
    80002214:	00006797          	auipc	a5,0x6
    80002218:	1cc78793          	addi	a5,a5,460 # 800083e0 <syscalls>
    8000221c:	97ba                	add	a5,a5,a4
    8000221e:	639c                	ld	a5,0(a5)
    80002220:	c789                	beqz	a5,8000222a <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002222:	9782                	jalr	a5
    80002224:	06a93823          	sd	a0,112(s2)
    80002228:	a00d                	j	8000224a <syscall+0x64>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000222a:	46048613          	addi	a2,s1,1120
    8000222e:	3384a583          	lw	a1,824(s1)
    80002232:	00006517          	auipc	a0,0x6
    80002236:	17650513          	addi	a0,a0,374 # 800083a8 <states.0+0x168>
    8000223a:	00004097          	auipc	ra,0x4
    8000223e:	f02080e7          	jalr	-254(ra) # 8000613c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002242:	3604b783          	ld	a5,864(s1)
    80002246:	577d                	li	a4,-1
    80002248:	fbb8                	sd	a4,112(a5)
  }
}
    8000224a:	60e2                	ld	ra,24(sp)
    8000224c:	6442                	ld	s0,16(sp)
    8000224e:	64a2                	ld	s1,8(sp)
    80002250:	6902                	ld	s2,0(sp)
    80002252:	6105                	addi	sp,sp,32
    80002254:	8082                	ret

0000000080002256 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002256:	1101                	addi	sp,sp,-32
    80002258:	ec06                	sd	ra,24(sp)
    8000225a:	e822                	sd	s0,16(sp)
    8000225c:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000225e:	fec40593          	addi	a1,s0,-20
    80002262:	4501                	li	a0,0
    80002264:	00000097          	auipc	ra,0x0
    80002268:	f0e080e7          	jalr	-242(ra) # 80002172 <argint>
    return -1;
    8000226c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000226e:	00054963          	bltz	a0,80002280 <sys_exit+0x2a>
  exit(n);
    80002272:	fec42503          	lw	a0,-20(s0)
    80002276:	fffff097          	auipc	ra,0xfffff
    8000227a:	592080e7          	jalr	1426(ra) # 80001808 <exit>
  return 0;  // not reached
    8000227e:	4781                	li	a5,0
}
    80002280:	853e                	mv	a0,a5
    80002282:	60e2                	ld	ra,24(sp)
    80002284:	6442                	ld	s0,16(sp)
    80002286:	6105                	addi	sp,sp,32
    80002288:	8082                	ret

000000008000228a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000228a:	1141                	addi	sp,sp,-16
    8000228c:	e406                	sd	ra,8(sp)
    8000228e:	e022                	sd	s0,0(sp)
    80002290:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002292:	fffff097          	auipc	ra,0xfffff
    80002296:	bb4080e7          	jalr	-1100(ra) # 80000e46 <myproc>
}
    8000229a:	33852503          	lw	a0,824(a0)
    8000229e:	60a2                	ld	ra,8(sp)
    800022a0:	6402                	ld	s0,0(sp)
    800022a2:	0141                	addi	sp,sp,16
    800022a4:	8082                	ret

00000000800022a6 <sys_fork>:

uint64
sys_fork(void)
{
    800022a6:	1141                	addi	sp,sp,-16
    800022a8:	e406                	sd	ra,8(sp)
    800022aa:	e022                	sd	s0,0(sp)
    800022ac:	0800                	addi	s0,sp,16
  return fork();
    800022ae:	fffff097          	auipc	ra,0xfffff
    800022b2:	fb8080e7          	jalr	-72(ra) # 80001266 <fork>
}
    800022b6:	60a2                	ld	ra,8(sp)
    800022b8:	6402                	ld	s0,0(sp)
    800022ba:	0141                	addi	sp,sp,16
    800022bc:	8082                	ret

00000000800022be <sys_wait>:

uint64
sys_wait(void)
{
    800022be:	1101                	addi	sp,sp,-32
    800022c0:	ec06                	sd	ra,24(sp)
    800022c2:	e822                	sd	s0,16(sp)
    800022c4:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800022c6:	fe840593          	addi	a1,s0,-24
    800022ca:	4501                	li	a0,0
    800022cc:	00000097          	auipc	ra,0x0
    800022d0:	ec8080e7          	jalr	-312(ra) # 80002194 <argaddr>
    800022d4:	87aa                	mv	a5,a0
    return -1;
    800022d6:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800022d8:	0007c863          	bltz	a5,800022e8 <sys_wait+0x2a>
  return wait(p);
    800022dc:	fe843503          	ld	a0,-24(s0)
    800022e0:	fffff097          	auipc	ra,0xfffff
    800022e4:	324080e7          	jalr	804(ra) # 80001604 <wait>
}
    800022e8:	60e2                	ld	ra,24(sp)
    800022ea:	6442                	ld	s0,16(sp)
    800022ec:	6105                	addi	sp,sp,32
    800022ee:	8082                	ret

00000000800022f0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800022f0:	7179                	addi	sp,sp,-48
    800022f2:	f406                	sd	ra,40(sp)
    800022f4:	f022                	sd	s0,32(sp)
    800022f6:	ec26                	sd	s1,24(sp)
    800022f8:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800022fa:	fdc40593          	addi	a1,s0,-36
    800022fe:	4501                	li	a0,0
    80002300:	00000097          	auipc	ra,0x0
    80002304:	e72080e7          	jalr	-398(ra) # 80002172 <argint>
    80002308:	87aa                	mv	a5,a0
    return -1;
    8000230a:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000230c:	0207c163          	bltz	a5,8000232e <sys_sbrk+0x3e>
  addr = myproc()->sz;
    80002310:	fffff097          	auipc	ra,0xfffff
    80002314:	b36080e7          	jalr	-1226(ra) # 80000e46 <myproc>
    80002318:	35052483          	lw	s1,848(a0)
  if(growproc(n) < 0)
    8000231c:	fdc42503          	lw	a0,-36(s0)
    80002320:	fffff097          	auipc	ra,0xfffff
    80002324:	ec8080e7          	jalr	-312(ra) # 800011e8 <growproc>
    80002328:	00054863          	bltz	a0,80002338 <sys_sbrk+0x48>
    return -1;
  return addr;
    8000232c:	8526                	mv	a0,s1
}
    8000232e:	70a2                	ld	ra,40(sp)
    80002330:	7402                	ld	s0,32(sp)
    80002332:	64e2                	ld	s1,24(sp)
    80002334:	6145                	addi	sp,sp,48
    80002336:	8082                	ret
    return -1;
    80002338:	557d                	li	a0,-1
    8000233a:	bfd5                	j	8000232e <sys_sbrk+0x3e>

000000008000233c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000233c:	7139                	addi	sp,sp,-64
    8000233e:	fc06                	sd	ra,56(sp)
    80002340:	f822                	sd	s0,48(sp)
    80002342:	f426                	sd	s1,40(sp)
    80002344:	f04a                	sd	s2,32(sp)
    80002346:	ec4e                	sd	s3,24(sp)
    80002348:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000234a:	fcc40593          	addi	a1,s0,-52
    8000234e:	4501                	li	a0,0
    80002350:	00000097          	auipc	ra,0x0
    80002354:	e22080e7          	jalr	-478(ra) # 80002172 <argint>
    return -1;
    80002358:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000235a:	06054663          	bltz	a0,800023c6 <sys_sleep+0x8a>
  acquire(&tickslock);
    8000235e:	00019517          	auipc	a0,0x19
    80002362:	d2250513          	addi	a0,a0,-734 # 8001b080 <tickslock>
    80002366:	00004097          	auipc	ra,0x4
    8000236a:	2c4080e7          	jalr	708(ra) # 8000662a <acquire>
  ticks0 = ticks;
    8000236e:	00007917          	auipc	s2,0x7
    80002372:	caa92903          	lw	s2,-854(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002376:	fcc42783          	lw	a5,-52(s0)
    8000237a:	cf8d                	beqz	a5,800023b4 <sys_sleep+0x78>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000237c:	00019997          	auipc	s3,0x19
    80002380:	d0498993          	addi	s3,s3,-764 # 8001b080 <tickslock>
    80002384:	00007497          	auipc	s1,0x7
    80002388:	c9448493          	addi	s1,s1,-876 # 80009018 <ticks>
    if(myproc()->killed){
    8000238c:	fffff097          	auipc	ra,0xfffff
    80002390:	aba080e7          	jalr	-1350(ra) # 80000e46 <myproc>
    80002394:	33052783          	lw	a5,816(a0)
    80002398:	ef9d                	bnez	a5,800023d6 <sys_sleep+0x9a>
    sleep(&ticks, &tickslock);
    8000239a:	85ce                	mv	a1,s3
    8000239c:	8526                	mv	a0,s1
    8000239e:	fffff097          	auipc	ra,0xfffff
    800023a2:	200080e7          	jalr	512(ra) # 8000159e <sleep>
  while(ticks - ticks0 < n){
    800023a6:	409c                	lw	a5,0(s1)
    800023a8:	412787bb          	subw	a5,a5,s2
    800023ac:	fcc42703          	lw	a4,-52(s0)
    800023b0:	fce7eee3          	bltu	a5,a4,8000238c <sys_sleep+0x50>
  }
  release(&tickslock);
    800023b4:	00019517          	auipc	a0,0x19
    800023b8:	ccc50513          	addi	a0,a0,-820 # 8001b080 <tickslock>
    800023bc:	00004097          	auipc	ra,0x4
    800023c0:	322080e7          	jalr	802(ra) # 800066de <release>
  return 0;
    800023c4:	4781                	li	a5,0
}
    800023c6:	853e                	mv	a0,a5
    800023c8:	70e2                	ld	ra,56(sp)
    800023ca:	7442                	ld	s0,48(sp)
    800023cc:	74a2                	ld	s1,40(sp)
    800023ce:	7902                	ld	s2,32(sp)
    800023d0:	69e2                	ld	s3,24(sp)
    800023d2:	6121                	addi	sp,sp,64
    800023d4:	8082                	ret
      release(&tickslock);
    800023d6:	00019517          	auipc	a0,0x19
    800023da:	caa50513          	addi	a0,a0,-854 # 8001b080 <tickslock>
    800023de:	00004097          	auipc	ra,0x4
    800023e2:	300080e7          	jalr	768(ra) # 800066de <release>
      return -1;
    800023e6:	57fd                	li	a5,-1
    800023e8:	bff9                	j	800023c6 <sys_sleep+0x8a>

00000000800023ea <sys_kill>:

uint64
sys_kill(void)
{
    800023ea:	1101                	addi	sp,sp,-32
    800023ec:	ec06                	sd	ra,24(sp)
    800023ee:	e822                	sd	s0,16(sp)
    800023f0:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800023f2:	fec40593          	addi	a1,s0,-20
    800023f6:	4501                	li	a0,0
    800023f8:	00000097          	auipc	ra,0x0
    800023fc:	d7a080e7          	jalr	-646(ra) # 80002172 <argint>
    80002400:	87aa                	mv	a5,a0
    return -1;
    80002402:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002404:	0007c863          	bltz	a5,80002414 <sys_kill+0x2a>
  return kill(pid);
    80002408:	fec42503          	lw	a0,-20(s0)
    8000240c:	fffff097          	auipc	ra,0xfffff
    80002410:	56e080e7          	jalr	1390(ra) # 8000197a <kill>
}
    80002414:	60e2                	ld	ra,24(sp)
    80002416:	6442                	ld	s0,16(sp)
    80002418:	6105                	addi	sp,sp,32
    8000241a:	8082                	ret

000000008000241c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000241c:	1101                	addi	sp,sp,-32
    8000241e:	ec06                	sd	ra,24(sp)
    80002420:	e822                	sd	s0,16(sp)
    80002422:	e426                	sd	s1,8(sp)
    80002424:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002426:	00019517          	auipc	a0,0x19
    8000242a:	c5a50513          	addi	a0,a0,-934 # 8001b080 <tickslock>
    8000242e:	00004097          	auipc	ra,0x4
    80002432:	1fc080e7          	jalr	508(ra) # 8000662a <acquire>
  xticks = ticks;
    80002436:	00007497          	auipc	s1,0x7
    8000243a:	be24a483          	lw	s1,-1054(s1) # 80009018 <ticks>
  release(&tickslock);
    8000243e:	00019517          	auipc	a0,0x19
    80002442:	c4250513          	addi	a0,a0,-958 # 8001b080 <tickslock>
    80002446:	00004097          	auipc	ra,0x4
    8000244a:	298080e7          	jalr	664(ra) # 800066de <release>
  return xticks;
}
    8000244e:	02049513          	slli	a0,s1,0x20
    80002452:	9101                	srli	a0,a0,0x20
    80002454:	60e2                	ld	ra,24(sp)
    80002456:	6442                	ld	s0,16(sp)
    80002458:	64a2                	ld	s1,8(sp)
    8000245a:	6105                	addi	sp,sp,32
    8000245c:	8082                	ret

000000008000245e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000245e:	7179                	addi	sp,sp,-48
    80002460:	f406                	sd	ra,40(sp)
    80002462:	f022                	sd	s0,32(sp)
    80002464:	ec26                	sd	s1,24(sp)
    80002466:	e84a                	sd	s2,16(sp)
    80002468:	e44e                	sd	s3,8(sp)
    8000246a:	e052                	sd	s4,0(sp)
    8000246c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000246e:	00006597          	auipc	a1,0x6
    80002472:	03258593          	addi	a1,a1,50 # 800084a0 <syscalls+0xc0>
    80002476:	00019517          	auipc	a0,0x19
    8000247a:	c2250513          	addi	a0,a0,-990 # 8001b098 <bcache>
    8000247e:	00004097          	auipc	ra,0x4
    80002482:	11c080e7          	jalr	284(ra) # 8000659a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002486:	00021797          	auipc	a5,0x21
    8000248a:	c1278793          	addi	a5,a5,-1006 # 80023098 <bcache+0x8000>
    8000248e:	00021717          	auipc	a4,0x21
    80002492:	e7270713          	addi	a4,a4,-398 # 80023300 <bcache+0x8268>
    80002496:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000249a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000249e:	00019497          	auipc	s1,0x19
    800024a2:	c1248493          	addi	s1,s1,-1006 # 8001b0b0 <bcache+0x18>
    b->next = bcache.head.next;
    800024a6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024a8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024aa:	00006a17          	auipc	s4,0x6
    800024ae:	ffea0a13          	addi	s4,s4,-2 # 800084a8 <syscalls+0xc8>
    b->next = bcache.head.next;
    800024b2:	2b893783          	ld	a5,696(s2)
    800024b6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024b8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024bc:	85d2                	mv	a1,s4
    800024be:	01048513          	addi	a0,s1,16
    800024c2:	00001097          	auipc	ra,0x1
    800024c6:	4c2080e7          	jalr	1218(ra) # 80003984 <initsleeplock>
    bcache.head.next->prev = b;
    800024ca:	2b893783          	ld	a5,696(s2)
    800024ce:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024d0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024d4:	45848493          	addi	s1,s1,1112
    800024d8:	fd349de3          	bne	s1,s3,800024b2 <binit+0x54>
  }
}
    800024dc:	70a2                	ld	ra,40(sp)
    800024de:	7402                	ld	s0,32(sp)
    800024e0:	64e2                	ld	s1,24(sp)
    800024e2:	6942                	ld	s2,16(sp)
    800024e4:	69a2                	ld	s3,8(sp)
    800024e6:	6a02                	ld	s4,0(sp)
    800024e8:	6145                	addi	sp,sp,48
    800024ea:	8082                	ret

00000000800024ec <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800024ec:	7179                	addi	sp,sp,-48
    800024ee:	f406                	sd	ra,40(sp)
    800024f0:	f022                	sd	s0,32(sp)
    800024f2:	ec26                	sd	s1,24(sp)
    800024f4:	e84a                	sd	s2,16(sp)
    800024f6:	e44e                	sd	s3,8(sp)
    800024f8:	1800                	addi	s0,sp,48
    800024fa:	892a                	mv	s2,a0
    800024fc:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800024fe:	00019517          	auipc	a0,0x19
    80002502:	b9a50513          	addi	a0,a0,-1126 # 8001b098 <bcache>
    80002506:	00004097          	auipc	ra,0x4
    8000250a:	124080e7          	jalr	292(ra) # 8000662a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000250e:	00021497          	auipc	s1,0x21
    80002512:	e424b483          	ld	s1,-446(s1) # 80023350 <bcache+0x82b8>
    80002516:	00021797          	auipc	a5,0x21
    8000251a:	dea78793          	addi	a5,a5,-534 # 80023300 <bcache+0x8268>
    8000251e:	02f48f63          	beq	s1,a5,8000255c <bread+0x70>
    80002522:	873e                	mv	a4,a5
    80002524:	a021                	j	8000252c <bread+0x40>
    80002526:	68a4                	ld	s1,80(s1)
    80002528:	02e48a63          	beq	s1,a4,8000255c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000252c:	449c                	lw	a5,8(s1)
    8000252e:	ff279ce3          	bne	a5,s2,80002526 <bread+0x3a>
    80002532:	44dc                	lw	a5,12(s1)
    80002534:	ff3799e3          	bne	a5,s3,80002526 <bread+0x3a>
      b->refcnt++;
    80002538:	40bc                	lw	a5,64(s1)
    8000253a:	2785                	addiw	a5,a5,1
    8000253c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000253e:	00019517          	auipc	a0,0x19
    80002542:	b5a50513          	addi	a0,a0,-1190 # 8001b098 <bcache>
    80002546:	00004097          	auipc	ra,0x4
    8000254a:	198080e7          	jalr	408(ra) # 800066de <release>
      acquiresleep(&b->lock);
    8000254e:	01048513          	addi	a0,s1,16
    80002552:	00001097          	auipc	ra,0x1
    80002556:	46c080e7          	jalr	1132(ra) # 800039be <acquiresleep>
      return b;
    8000255a:	a8b9                	j	800025b8 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000255c:	00021497          	auipc	s1,0x21
    80002560:	dec4b483          	ld	s1,-532(s1) # 80023348 <bcache+0x82b0>
    80002564:	00021797          	auipc	a5,0x21
    80002568:	d9c78793          	addi	a5,a5,-612 # 80023300 <bcache+0x8268>
    8000256c:	00f48863          	beq	s1,a5,8000257c <bread+0x90>
    80002570:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002572:	40bc                	lw	a5,64(s1)
    80002574:	cf81                	beqz	a5,8000258c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002576:	64a4                	ld	s1,72(s1)
    80002578:	fee49de3          	bne	s1,a4,80002572 <bread+0x86>
  panic("bget: no buffers");
    8000257c:	00006517          	auipc	a0,0x6
    80002580:	f3450513          	addi	a0,a0,-204 # 800084b0 <syscalls+0xd0>
    80002584:	00004097          	auipc	ra,0x4
    80002588:	b6e080e7          	jalr	-1170(ra) # 800060f2 <panic>
      b->dev = dev;
    8000258c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002590:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002594:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002598:	4785                	li	a5,1
    8000259a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000259c:	00019517          	auipc	a0,0x19
    800025a0:	afc50513          	addi	a0,a0,-1284 # 8001b098 <bcache>
    800025a4:	00004097          	auipc	ra,0x4
    800025a8:	13a080e7          	jalr	314(ra) # 800066de <release>
      acquiresleep(&b->lock);
    800025ac:	01048513          	addi	a0,s1,16
    800025b0:	00001097          	auipc	ra,0x1
    800025b4:	40e080e7          	jalr	1038(ra) # 800039be <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025b8:	409c                	lw	a5,0(s1)
    800025ba:	cb89                	beqz	a5,800025cc <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025bc:	8526                	mv	a0,s1
    800025be:	70a2                	ld	ra,40(sp)
    800025c0:	7402                	ld	s0,32(sp)
    800025c2:	64e2                	ld	s1,24(sp)
    800025c4:	6942                	ld	s2,16(sp)
    800025c6:	69a2                	ld	s3,8(sp)
    800025c8:	6145                	addi	sp,sp,48
    800025ca:	8082                	ret
    virtio_disk_rw(b, 0);
    800025cc:	4581                	li	a1,0
    800025ce:	8526                	mv	a0,s1
    800025d0:	00003097          	auipc	ra,0x3
    800025d4:	2b2080e7          	jalr	690(ra) # 80005882 <virtio_disk_rw>
    b->valid = 1;
    800025d8:	4785                	li	a5,1
    800025da:	c09c                	sw	a5,0(s1)
  return b;
    800025dc:	b7c5                	j	800025bc <bread+0xd0>

00000000800025de <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025de:	1101                	addi	sp,sp,-32
    800025e0:	ec06                	sd	ra,24(sp)
    800025e2:	e822                	sd	s0,16(sp)
    800025e4:	e426                	sd	s1,8(sp)
    800025e6:	1000                	addi	s0,sp,32
    800025e8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025ea:	0541                	addi	a0,a0,16
    800025ec:	00001097          	auipc	ra,0x1
    800025f0:	46e080e7          	jalr	1134(ra) # 80003a5a <holdingsleep>
    800025f4:	cd01                	beqz	a0,8000260c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800025f6:	4585                	li	a1,1
    800025f8:	8526                	mv	a0,s1
    800025fa:	00003097          	auipc	ra,0x3
    800025fe:	288080e7          	jalr	648(ra) # 80005882 <virtio_disk_rw>
}
    80002602:	60e2                	ld	ra,24(sp)
    80002604:	6442                	ld	s0,16(sp)
    80002606:	64a2                	ld	s1,8(sp)
    80002608:	6105                	addi	sp,sp,32
    8000260a:	8082                	ret
    panic("bwrite");
    8000260c:	00006517          	auipc	a0,0x6
    80002610:	ebc50513          	addi	a0,a0,-324 # 800084c8 <syscalls+0xe8>
    80002614:	00004097          	auipc	ra,0x4
    80002618:	ade080e7          	jalr	-1314(ra) # 800060f2 <panic>

000000008000261c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000261c:	1101                	addi	sp,sp,-32
    8000261e:	ec06                	sd	ra,24(sp)
    80002620:	e822                	sd	s0,16(sp)
    80002622:	e426                	sd	s1,8(sp)
    80002624:	e04a                	sd	s2,0(sp)
    80002626:	1000                	addi	s0,sp,32
    80002628:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000262a:	01050913          	addi	s2,a0,16
    8000262e:	854a                	mv	a0,s2
    80002630:	00001097          	auipc	ra,0x1
    80002634:	42a080e7          	jalr	1066(ra) # 80003a5a <holdingsleep>
    80002638:	c92d                	beqz	a0,800026aa <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000263a:	854a                	mv	a0,s2
    8000263c:	00001097          	auipc	ra,0x1
    80002640:	3da080e7          	jalr	986(ra) # 80003a16 <releasesleep>

  acquire(&bcache.lock);
    80002644:	00019517          	auipc	a0,0x19
    80002648:	a5450513          	addi	a0,a0,-1452 # 8001b098 <bcache>
    8000264c:	00004097          	auipc	ra,0x4
    80002650:	fde080e7          	jalr	-34(ra) # 8000662a <acquire>
  b->refcnt--;
    80002654:	40bc                	lw	a5,64(s1)
    80002656:	37fd                	addiw	a5,a5,-1
    80002658:	0007871b          	sext.w	a4,a5
    8000265c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000265e:	eb05                	bnez	a4,8000268e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002660:	68bc                	ld	a5,80(s1)
    80002662:	64b8                	ld	a4,72(s1)
    80002664:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002666:	64bc                	ld	a5,72(s1)
    80002668:	68b8                	ld	a4,80(s1)
    8000266a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000266c:	00021797          	auipc	a5,0x21
    80002670:	a2c78793          	addi	a5,a5,-1492 # 80023098 <bcache+0x8000>
    80002674:	2b87b703          	ld	a4,696(a5)
    80002678:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000267a:	00021717          	auipc	a4,0x21
    8000267e:	c8670713          	addi	a4,a4,-890 # 80023300 <bcache+0x8268>
    80002682:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002684:	2b87b703          	ld	a4,696(a5)
    80002688:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000268a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000268e:	00019517          	auipc	a0,0x19
    80002692:	a0a50513          	addi	a0,a0,-1526 # 8001b098 <bcache>
    80002696:	00004097          	auipc	ra,0x4
    8000269a:	048080e7          	jalr	72(ra) # 800066de <release>
}
    8000269e:	60e2                	ld	ra,24(sp)
    800026a0:	6442                	ld	s0,16(sp)
    800026a2:	64a2                	ld	s1,8(sp)
    800026a4:	6902                	ld	s2,0(sp)
    800026a6:	6105                	addi	sp,sp,32
    800026a8:	8082                	ret
    panic("brelse");
    800026aa:	00006517          	auipc	a0,0x6
    800026ae:	e2650513          	addi	a0,a0,-474 # 800084d0 <syscalls+0xf0>
    800026b2:	00004097          	auipc	ra,0x4
    800026b6:	a40080e7          	jalr	-1472(ra) # 800060f2 <panic>

00000000800026ba <bpin>:

void
bpin(struct buf *b) {
    800026ba:	1101                	addi	sp,sp,-32
    800026bc:	ec06                	sd	ra,24(sp)
    800026be:	e822                	sd	s0,16(sp)
    800026c0:	e426                	sd	s1,8(sp)
    800026c2:	1000                	addi	s0,sp,32
    800026c4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026c6:	00019517          	auipc	a0,0x19
    800026ca:	9d250513          	addi	a0,a0,-1582 # 8001b098 <bcache>
    800026ce:	00004097          	auipc	ra,0x4
    800026d2:	f5c080e7          	jalr	-164(ra) # 8000662a <acquire>
  b->refcnt++;
    800026d6:	40bc                	lw	a5,64(s1)
    800026d8:	2785                	addiw	a5,a5,1
    800026da:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026dc:	00019517          	auipc	a0,0x19
    800026e0:	9bc50513          	addi	a0,a0,-1604 # 8001b098 <bcache>
    800026e4:	00004097          	auipc	ra,0x4
    800026e8:	ffa080e7          	jalr	-6(ra) # 800066de <release>
}
    800026ec:	60e2                	ld	ra,24(sp)
    800026ee:	6442                	ld	s0,16(sp)
    800026f0:	64a2                	ld	s1,8(sp)
    800026f2:	6105                	addi	sp,sp,32
    800026f4:	8082                	ret

00000000800026f6 <bunpin>:

void
bunpin(struct buf *b) {
    800026f6:	1101                	addi	sp,sp,-32
    800026f8:	ec06                	sd	ra,24(sp)
    800026fa:	e822                	sd	s0,16(sp)
    800026fc:	e426                	sd	s1,8(sp)
    800026fe:	1000                	addi	s0,sp,32
    80002700:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002702:	00019517          	auipc	a0,0x19
    80002706:	99650513          	addi	a0,a0,-1642 # 8001b098 <bcache>
    8000270a:	00004097          	auipc	ra,0x4
    8000270e:	f20080e7          	jalr	-224(ra) # 8000662a <acquire>
  b->refcnt--;
    80002712:	40bc                	lw	a5,64(s1)
    80002714:	37fd                	addiw	a5,a5,-1
    80002716:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002718:	00019517          	auipc	a0,0x19
    8000271c:	98050513          	addi	a0,a0,-1664 # 8001b098 <bcache>
    80002720:	00004097          	auipc	ra,0x4
    80002724:	fbe080e7          	jalr	-66(ra) # 800066de <release>
}
    80002728:	60e2                	ld	ra,24(sp)
    8000272a:	6442                	ld	s0,16(sp)
    8000272c:	64a2                	ld	s1,8(sp)
    8000272e:	6105                	addi	sp,sp,32
    80002730:	8082                	ret

0000000080002732 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002732:	1101                	addi	sp,sp,-32
    80002734:	ec06                	sd	ra,24(sp)
    80002736:	e822                	sd	s0,16(sp)
    80002738:	e426                	sd	s1,8(sp)
    8000273a:	e04a                	sd	s2,0(sp)
    8000273c:	1000                	addi	s0,sp,32
    8000273e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002740:	00d5d59b          	srliw	a1,a1,0xd
    80002744:	00021797          	auipc	a5,0x21
    80002748:	0307a783          	lw	a5,48(a5) # 80023774 <sb+0x1c>
    8000274c:	9dbd                	addw	a1,a1,a5
    8000274e:	00000097          	auipc	ra,0x0
    80002752:	d9e080e7          	jalr	-610(ra) # 800024ec <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002756:	0074f713          	andi	a4,s1,7
    8000275a:	4785                	li	a5,1
    8000275c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002760:	14ce                	slli	s1,s1,0x33
    80002762:	90d9                	srli	s1,s1,0x36
    80002764:	00950733          	add	a4,a0,s1
    80002768:	05874703          	lbu	a4,88(a4)
    8000276c:	00e7f6b3          	and	a3,a5,a4
    80002770:	c69d                	beqz	a3,8000279e <bfree+0x6c>
    80002772:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002774:	94aa                	add	s1,s1,a0
    80002776:	fff7c793          	not	a5,a5
    8000277a:	8f7d                	and	a4,a4,a5
    8000277c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002780:	00001097          	auipc	ra,0x1
    80002784:	120080e7          	jalr	288(ra) # 800038a0 <log_write>
  brelse(bp);
    80002788:	854a                	mv	a0,s2
    8000278a:	00000097          	auipc	ra,0x0
    8000278e:	e92080e7          	jalr	-366(ra) # 8000261c <brelse>
}
    80002792:	60e2                	ld	ra,24(sp)
    80002794:	6442                	ld	s0,16(sp)
    80002796:	64a2                	ld	s1,8(sp)
    80002798:	6902                	ld	s2,0(sp)
    8000279a:	6105                	addi	sp,sp,32
    8000279c:	8082                	ret
    panic("freeing free block");
    8000279e:	00006517          	auipc	a0,0x6
    800027a2:	d3a50513          	addi	a0,a0,-710 # 800084d8 <syscalls+0xf8>
    800027a6:	00004097          	auipc	ra,0x4
    800027aa:	94c080e7          	jalr	-1716(ra) # 800060f2 <panic>

00000000800027ae <balloc>:
{
    800027ae:	711d                	addi	sp,sp,-96
    800027b0:	ec86                	sd	ra,88(sp)
    800027b2:	e8a2                	sd	s0,80(sp)
    800027b4:	e4a6                	sd	s1,72(sp)
    800027b6:	e0ca                	sd	s2,64(sp)
    800027b8:	fc4e                	sd	s3,56(sp)
    800027ba:	f852                	sd	s4,48(sp)
    800027bc:	f456                	sd	s5,40(sp)
    800027be:	f05a                	sd	s6,32(sp)
    800027c0:	ec5e                	sd	s7,24(sp)
    800027c2:	e862                	sd	s8,16(sp)
    800027c4:	e466                	sd	s9,8(sp)
    800027c6:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027c8:	00021797          	auipc	a5,0x21
    800027cc:	f947a783          	lw	a5,-108(a5) # 8002375c <sb+0x4>
    800027d0:	cbc1                	beqz	a5,80002860 <balloc+0xb2>
    800027d2:	8baa                	mv	s7,a0
    800027d4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027d6:	00021b17          	auipc	s6,0x21
    800027da:	f82b0b13          	addi	s6,s6,-126 # 80023758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027de:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800027e0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027e2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800027e4:	6c89                	lui	s9,0x2
    800027e6:	a831                	j	80002802 <balloc+0x54>
    brelse(bp);
    800027e8:	854a                	mv	a0,s2
    800027ea:	00000097          	auipc	ra,0x0
    800027ee:	e32080e7          	jalr	-462(ra) # 8000261c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027f2:	015c87bb          	addw	a5,s9,s5
    800027f6:	00078a9b          	sext.w	s5,a5
    800027fa:	004b2703          	lw	a4,4(s6)
    800027fe:	06eaf163          	bgeu	s5,a4,80002860 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002802:	41fad79b          	sraiw	a5,s5,0x1f
    80002806:	0137d79b          	srliw	a5,a5,0x13
    8000280a:	015787bb          	addw	a5,a5,s5
    8000280e:	40d7d79b          	sraiw	a5,a5,0xd
    80002812:	01cb2583          	lw	a1,28(s6)
    80002816:	9dbd                	addw	a1,a1,a5
    80002818:	855e                	mv	a0,s7
    8000281a:	00000097          	auipc	ra,0x0
    8000281e:	cd2080e7          	jalr	-814(ra) # 800024ec <bread>
    80002822:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002824:	004b2503          	lw	a0,4(s6)
    80002828:	000a849b          	sext.w	s1,s5
    8000282c:	8762                	mv	a4,s8
    8000282e:	faa4fde3          	bgeu	s1,a0,800027e8 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002832:	00777693          	andi	a3,a4,7
    80002836:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000283a:	41f7579b          	sraiw	a5,a4,0x1f
    8000283e:	01d7d79b          	srliw	a5,a5,0x1d
    80002842:	9fb9                	addw	a5,a5,a4
    80002844:	4037d79b          	sraiw	a5,a5,0x3
    80002848:	00f90633          	add	a2,s2,a5
    8000284c:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    80002850:	00c6f5b3          	and	a1,a3,a2
    80002854:	cd91                	beqz	a1,80002870 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002856:	2705                	addiw	a4,a4,1
    80002858:	2485                	addiw	s1,s1,1
    8000285a:	fd471ae3          	bne	a4,s4,8000282e <balloc+0x80>
    8000285e:	b769                	j	800027e8 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002860:	00006517          	auipc	a0,0x6
    80002864:	c9050513          	addi	a0,a0,-880 # 800084f0 <syscalls+0x110>
    80002868:	00004097          	auipc	ra,0x4
    8000286c:	88a080e7          	jalr	-1910(ra) # 800060f2 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002870:	97ca                	add	a5,a5,s2
    80002872:	8e55                	or	a2,a2,a3
    80002874:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002878:	854a                	mv	a0,s2
    8000287a:	00001097          	auipc	ra,0x1
    8000287e:	026080e7          	jalr	38(ra) # 800038a0 <log_write>
        brelse(bp);
    80002882:	854a                	mv	a0,s2
    80002884:	00000097          	auipc	ra,0x0
    80002888:	d98080e7          	jalr	-616(ra) # 8000261c <brelse>
  bp = bread(dev, bno);
    8000288c:	85a6                	mv	a1,s1
    8000288e:	855e                	mv	a0,s7
    80002890:	00000097          	auipc	ra,0x0
    80002894:	c5c080e7          	jalr	-932(ra) # 800024ec <bread>
    80002898:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000289a:	40000613          	li	a2,1024
    8000289e:	4581                	li	a1,0
    800028a0:	05850513          	addi	a0,a0,88
    800028a4:	ffffe097          	auipc	ra,0xffffe
    800028a8:	8d6080e7          	jalr	-1834(ra) # 8000017a <memset>
  log_write(bp);
    800028ac:	854a                	mv	a0,s2
    800028ae:	00001097          	auipc	ra,0x1
    800028b2:	ff2080e7          	jalr	-14(ra) # 800038a0 <log_write>
  brelse(bp);
    800028b6:	854a                	mv	a0,s2
    800028b8:	00000097          	auipc	ra,0x0
    800028bc:	d64080e7          	jalr	-668(ra) # 8000261c <brelse>
}
    800028c0:	8526                	mv	a0,s1
    800028c2:	60e6                	ld	ra,88(sp)
    800028c4:	6446                	ld	s0,80(sp)
    800028c6:	64a6                	ld	s1,72(sp)
    800028c8:	6906                	ld	s2,64(sp)
    800028ca:	79e2                	ld	s3,56(sp)
    800028cc:	7a42                	ld	s4,48(sp)
    800028ce:	7aa2                	ld	s5,40(sp)
    800028d0:	7b02                	ld	s6,32(sp)
    800028d2:	6be2                	ld	s7,24(sp)
    800028d4:	6c42                	ld	s8,16(sp)
    800028d6:	6ca2                	ld	s9,8(sp)
    800028d8:	6125                	addi	sp,sp,96
    800028da:	8082                	ret

00000000800028dc <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800028dc:	7179                	addi	sp,sp,-48
    800028de:	f406                	sd	ra,40(sp)
    800028e0:	f022                	sd	s0,32(sp)
    800028e2:	ec26                	sd	s1,24(sp)
    800028e4:	e84a                	sd	s2,16(sp)
    800028e6:	e44e                	sd	s3,8(sp)
    800028e8:	e052                	sd	s4,0(sp)
    800028ea:	1800                	addi	s0,sp,48
    800028ec:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800028ee:	47ad                	li	a5,11
    800028f0:	04b7fe63          	bgeu	a5,a1,8000294c <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800028f4:	ff45849b          	addiw	s1,a1,-12
    800028f8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028fc:	0ff00793          	li	a5,255
    80002900:	0ae7e463          	bltu	a5,a4,800029a8 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002904:	08052583          	lw	a1,128(a0)
    80002908:	c5b5                	beqz	a1,80002974 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000290a:	00092503          	lw	a0,0(s2)
    8000290e:	00000097          	auipc	ra,0x0
    80002912:	bde080e7          	jalr	-1058(ra) # 800024ec <bread>
    80002916:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002918:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000291c:	02049713          	slli	a4,s1,0x20
    80002920:	01e75593          	srli	a1,a4,0x1e
    80002924:	00b784b3          	add	s1,a5,a1
    80002928:	0004a983          	lw	s3,0(s1)
    8000292c:	04098e63          	beqz	s3,80002988 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002930:	8552                	mv	a0,s4
    80002932:	00000097          	auipc	ra,0x0
    80002936:	cea080e7          	jalr	-790(ra) # 8000261c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000293a:	854e                	mv	a0,s3
    8000293c:	70a2                	ld	ra,40(sp)
    8000293e:	7402                	ld	s0,32(sp)
    80002940:	64e2                	ld	s1,24(sp)
    80002942:	6942                	ld	s2,16(sp)
    80002944:	69a2                	ld	s3,8(sp)
    80002946:	6a02                	ld	s4,0(sp)
    80002948:	6145                	addi	sp,sp,48
    8000294a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000294c:	02059793          	slli	a5,a1,0x20
    80002950:	01e7d593          	srli	a1,a5,0x1e
    80002954:	00b504b3          	add	s1,a0,a1
    80002958:	0504a983          	lw	s3,80(s1)
    8000295c:	fc099fe3          	bnez	s3,8000293a <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002960:	4108                	lw	a0,0(a0)
    80002962:	00000097          	auipc	ra,0x0
    80002966:	e4c080e7          	jalr	-436(ra) # 800027ae <balloc>
    8000296a:	0005099b          	sext.w	s3,a0
    8000296e:	0534a823          	sw	s3,80(s1)
    80002972:	b7e1                	j	8000293a <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002974:	4108                	lw	a0,0(a0)
    80002976:	00000097          	auipc	ra,0x0
    8000297a:	e38080e7          	jalr	-456(ra) # 800027ae <balloc>
    8000297e:	0005059b          	sext.w	a1,a0
    80002982:	08b92023          	sw	a1,128(s2)
    80002986:	b751                	j	8000290a <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002988:	00092503          	lw	a0,0(s2)
    8000298c:	00000097          	auipc	ra,0x0
    80002990:	e22080e7          	jalr	-478(ra) # 800027ae <balloc>
    80002994:	0005099b          	sext.w	s3,a0
    80002998:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000299c:	8552                	mv	a0,s4
    8000299e:	00001097          	auipc	ra,0x1
    800029a2:	f02080e7          	jalr	-254(ra) # 800038a0 <log_write>
    800029a6:	b769                	j	80002930 <bmap+0x54>
  panic("bmap: out of range");
    800029a8:	00006517          	auipc	a0,0x6
    800029ac:	b6050513          	addi	a0,a0,-1184 # 80008508 <syscalls+0x128>
    800029b0:	00003097          	auipc	ra,0x3
    800029b4:	742080e7          	jalr	1858(ra) # 800060f2 <panic>

00000000800029b8 <iget>:
{
    800029b8:	7179                	addi	sp,sp,-48
    800029ba:	f406                	sd	ra,40(sp)
    800029bc:	f022                	sd	s0,32(sp)
    800029be:	ec26                	sd	s1,24(sp)
    800029c0:	e84a                	sd	s2,16(sp)
    800029c2:	e44e                	sd	s3,8(sp)
    800029c4:	e052                	sd	s4,0(sp)
    800029c6:	1800                	addi	s0,sp,48
    800029c8:	89aa                	mv	s3,a0
    800029ca:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029cc:	00021517          	auipc	a0,0x21
    800029d0:	dac50513          	addi	a0,a0,-596 # 80023778 <itable>
    800029d4:	00004097          	auipc	ra,0x4
    800029d8:	c56080e7          	jalr	-938(ra) # 8000662a <acquire>
  empty = 0;
    800029dc:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029de:	00021497          	auipc	s1,0x21
    800029e2:	db248493          	addi	s1,s1,-590 # 80023790 <itable+0x18>
    800029e6:	00023697          	auipc	a3,0x23
    800029ea:	83a68693          	addi	a3,a3,-1990 # 80025220 <log>
    800029ee:	a039                	j	800029fc <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029f0:	02090b63          	beqz	s2,80002a26 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029f4:	08848493          	addi	s1,s1,136
    800029f8:	02d48a63          	beq	s1,a3,80002a2c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800029fc:	449c                	lw	a5,8(s1)
    800029fe:	fef059e3          	blez	a5,800029f0 <iget+0x38>
    80002a02:	4098                	lw	a4,0(s1)
    80002a04:	ff3716e3          	bne	a4,s3,800029f0 <iget+0x38>
    80002a08:	40d8                	lw	a4,4(s1)
    80002a0a:	ff4713e3          	bne	a4,s4,800029f0 <iget+0x38>
      ip->ref++;
    80002a0e:	2785                	addiw	a5,a5,1
    80002a10:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a12:	00021517          	auipc	a0,0x21
    80002a16:	d6650513          	addi	a0,a0,-666 # 80023778 <itable>
    80002a1a:	00004097          	auipc	ra,0x4
    80002a1e:	cc4080e7          	jalr	-828(ra) # 800066de <release>
      return ip;
    80002a22:	8926                	mv	s2,s1
    80002a24:	a03d                	j	80002a52 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a26:	f7f9                	bnez	a5,800029f4 <iget+0x3c>
    80002a28:	8926                	mv	s2,s1
    80002a2a:	b7e9                	j	800029f4 <iget+0x3c>
  if(empty == 0)
    80002a2c:	02090c63          	beqz	s2,80002a64 <iget+0xac>
  ip->dev = dev;
    80002a30:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a34:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a38:	4785                	li	a5,1
    80002a3a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a3e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a42:	00021517          	auipc	a0,0x21
    80002a46:	d3650513          	addi	a0,a0,-714 # 80023778 <itable>
    80002a4a:	00004097          	auipc	ra,0x4
    80002a4e:	c94080e7          	jalr	-876(ra) # 800066de <release>
}
    80002a52:	854a                	mv	a0,s2
    80002a54:	70a2                	ld	ra,40(sp)
    80002a56:	7402                	ld	s0,32(sp)
    80002a58:	64e2                	ld	s1,24(sp)
    80002a5a:	6942                	ld	s2,16(sp)
    80002a5c:	69a2                	ld	s3,8(sp)
    80002a5e:	6a02                	ld	s4,0(sp)
    80002a60:	6145                	addi	sp,sp,48
    80002a62:	8082                	ret
    panic("iget: no inodes");
    80002a64:	00006517          	auipc	a0,0x6
    80002a68:	abc50513          	addi	a0,a0,-1348 # 80008520 <syscalls+0x140>
    80002a6c:	00003097          	auipc	ra,0x3
    80002a70:	686080e7          	jalr	1670(ra) # 800060f2 <panic>

0000000080002a74 <fsinit>:
fsinit(int dev) {
    80002a74:	7179                	addi	sp,sp,-48
    80002a76:	f406                	sd	ra,40(sp)
    80002a78:	f022                	sd	s0,32(sp)
    80002a7a:	ec26                	sd	s1,24(sp)
    80002a7c:	e84a                	sd	s2,16(sp)
    80002a7e:	e44e                	sd	s3,8(sp)
    80002a80:	1800                	addi	s0,sp,48
    80002a82:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a84:	4585                	li	a1,1
    80002a86:	00000097          	auipc	ra,0x0
    80002a8a:	a66080e7          	jalr	-1434(ra) # 800024ec <bread>
    80002a8e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a90:	00021997          	auipc	s3,0x21
    80002a94:	cc898993          	addi	s3,s3,-824 # 80023758 <sb>
    80002a98:	02000613          	li	a2,32
    80002a9c:	05850593          	addi	a1,a0,88
    80002aa0:	854e                	mv	a0,s3
    80002aa2:	ffffd097          	auipc	ra,0xffffd
    80002aa6:	734080e7          	jalr	1844(ra) # 800001d6 <memmove>
  brelse(bp);
    80002aaa:	8526                	mv	a0,s1
    80002aac:	00000097          	auipc	ra,0x0
    80002ab0:	b70080e7          	jalr	-1168(ra) # 8000261c <brelse>
  if(sb.magic != FSMAGIC)
    80002ab4:	0009a703          	lw	a4,0(s3)
    80002ab8:	102037b7          	lui	a5,0x10203
    80002abc:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002ac0:	02f71263          	bne	a4,a5,80002ae4 <fsinit+0x70>
  initlog(dev, &sb);
    80002ac4:	00021597          	auipc	a1,0x21
    80002ac8:	c9458593          	addi	a1,a1,-876 # 80023758 <sb>
    80002acc:	854a                	mv	a0,s2
    80002ace:	00001097          	auipc	ra,0x1
    80002ad2:	b56080e7          	jalr	-1194(ra) # 80003624 <initlog>
}
    80002ad6:	70a2                	ld	ra,40(sp)
    80002ad8:	7402                	ld	s0,32(sp)
    80002ada:	64e2                	ld	s1,24(sp)
    80002adc:	6942                	ld	s2,16(sp)
    80002ade:	69a2                	ld	s3,8(sp)
    80002ae0:	6145                	addi	sp,sp,48
    80002ae2:	8082                	ret
    panic("invalid file system");
    80002ae4:	00006517          	auipc	a0,0x6
    80002ae8:	a4c50513          	addi	a0,a0,-1460 # 80008530 <syscalls+0x150>
    80002aec:	00003097          	auipc	ra,0x3
    80002af0:	606080e7          	jalr	1542(ra) # 800060f2 <panic>

0000000080002af4 <iinit>:
{
    80002af4:	7179                	addi	sp,sp,-48
    80002af6:	f406                	sd	ra,40(sp)
    80002af8:	f022                	sd	s0,32(sp)
    80002afa:	ec26                	sd	s1,24(sp)
    80002afc:	e84a                	sd	s2,16(sp)
    80002afe:	e44e                	sd	s3,8(sp)
    80002b00:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b02:	00006597          	auipc	a1,0x6
    80002b06:	a4658593          	addi	a1,a1,-1466 # 80008548 <syscalls+0x168>
    80002b0a:	00021517          	auipc	a0,0x21
    80002b0e:	c6e50513          	addi	a0,a0,-914 # 80023778 <itable>
    80002b12:	00004097          	auipc	ra,0x4
    80002b16:	a88080e7          	jalr	-1400(ra) # 8000659a <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b1a:	00021497          	auipc	s1,0x21
    80002b1e:	c8648493          	addi	s1,s1,-890 # 800237a0 <itable+0x28>
    80002b22:	00022997          	auipc	s3,0x22
    80002b26:	70e98993          	addi	s3,s3,1806 # 80025230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b2a:	00006917          	auipc	s2,0x6
    80002b2e:	a2690913          	addi	s2,s2,-1498 # 80008550 <syscalls+0x170>
    80002b32:	85ca                	mv	a1,s2
    80002b34:	8526                	mv	a0,s1
    80002b36:	00001097          	auipc	ra,0x1
    80002b3a:	e4e080e7          	jalr	-434(ra) # 80003984 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b3e:	08848493          	addi	s1,s1,136
    80002b42:	ff3498e3          	bne	s1,s3,80002b32 <iinit+0x3e>
}
    80002b46:	70a2                	ld	ra,40(sp)
    80002b48:	7402                	ld	s0,32(sp)
    80002b4a:	64e2                	ld	s1,24(sp)
    80002b4c:	6942                	ld	s2,16(sp)
    80002b4e:	69a2                	ld	s3,8(sp)
    80002b50:	6145                	addi	sp,sp,48
    80002b52:	8082                	ret

0000000080002b54 <ialloc>:
{
    80002b54:	715d                	addi	sp,sp,-80
    80002b56:	e486                	sd	ra,72(sp)
    80002b58:	e0a2                	sd	s0,64(sp)
    80002b5a:	fc26                	sd	s1,56(sp)
    80002b5c:	f84a                	sd	s2,48(sp)
    80002b5e:	f44e                	sd	s3,40(sp)
    80002b60:	f052                	sd	s4,32(sp)
    80002b62:	ec56                	sd	s5,24(sp)
    80002b64:	e85a                	sd	s6,16(sp)
    80002b66:	e45e                	sd	s7,8(sp)
    80002b68:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b6a:	00021717          	auipc	a4,0x21
    80002b6e:	bfa72703          	lw	a4,-1030(a4) # 80023764 <sb+0xc>
    80002b72:	4785                	li	a5,1
    80002b74:	04e7fa63          	bgeu	a5,a4,80002bc8 <ialloc+0x74>
    80002b78:	8aaa                	mv	s5,a0
    80002b7a:	8bae                	mv	s7,a1
    80002b7c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b7e:	00021a17          	auipc	s4,0x21
    80002b82:	bdaa0a13          	addi	s4,s4,-1062 # 80023758 <sb>
    80002b86:	00048b1b          	sext.w	s6,s1
    80002b8a:	0044d593          	srli	a1,s1,0x4
    80002b8e:	018a2783          	lw	a5,24(s4)
    80002b92:	9dbd                	addw	a1,a1,a5
    80002b94:	8556                	mv	a0,s5
    80002b96:	00000097          	auipc	ra,0x0
    80002b9a:	956080e7          	jalr	-1706(ra) # 800024ec <bread>
    80002b9e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002ba0:	05850993          	addi	s3,a0,88
    80002ba4:	00f4f793          	andi	a5,s1,15
    80002ba8:	079a                	slli	a5,a5,0x6
    80002baa:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bac:	00099783          	lh	a5,0(s3)
    80002bb0:	c785                	beqz	a5,80002bd8 <ialloc+0x84>
    brelse(bp);
    80002bb2:	00000097          	auipc	ra,0x0
    80002bb6:	a6a080e7          	jalr	-1430(ra) # 8000261c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bba:	0485                	addi	s1,s1,1
    80002bbc:	00ca2703          	lw	a4,12(s4)
    80002bc0:	0004879b          	sext.w	a5,s1
    80002bc4:	fce7e1e3          	bltu	a5,a4,80002b86 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002bc8:	00006517          	auipc	a0,0x6
    80002bcc:	99050513          	addi	a0,a0,-1648 # 80008558 <syscalls+0x178>
    80002bd0:	00003097          	auipc	ra,0x3
    80002bd4:	522080e7          	jalr	1314(ra) # 800060f2 <panic>
      memset(dip, 0, sizeof(*dip));
    80002bd8:	04000613          	li	a2,64
    80002bdc:	4581                	li	a1,0
    80002bde:	854e                	mv	a0,s3
    80002be0:	ffffd097          	auipc	ra,0xffffd
    80002be4:	59a080e7          	jalr	1434(ra) # 8000017a <memset>
      dip->type = type;
    80002be8:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002bec:	854a                	mv	a0,s2
    80002bee:	00001097          	auipc	ra,0x1
    80002bf2:	cb2080e7          	jalr	-846(ra) # 800038a0 <log_write>
      brelse(bp);
    80002bf6:	854a                	mv	a0,s2
    80002bf8:	00000097          	auipc	ra,0x0
    80002bfc:	a24080e7          	jalr	-1500(ra) # 8000261c <brelse>
      return iget(dev, inum);
    80002c00:	85da                	mv	a1,s6
    80002c02:	8556                	mv	a0,s5
    80002c04:	00000097          	auipc	ra,0x0
    80002c08:	db4080e7          	jalr	-588(ra) # 800029b8 <iget>
}
    80002c0c:	60a6                	ld	ra,72(sp)
    80002c0e:	6406                	ld	s0,64(sp)
    80002c10:	74e2                	ld	s1,56(sp)
    80002c12:	7942                	ld	s2,48(sp)
    80002c14:	79a2                	ld	s3,40(sp)
    80002c16:	7a02                	ld	s4,32(sp)
    80002c18:	6ae2                	ld	s5,24(sp)
    80002c1a:	6b42                	ld	s6,16(sp)
    80002c1c:	6ba2                	ld	s7,8(sp)
    80002c1e:	6161                	addi	sp,sp,80
    80002c20:	8082                	ret

0000000080002c22 <iupdate>:
{
    80002c22:	1101                	addi	sp,sp,-32
    80002c24:	ec06                	sd	ra,24(sp)
    80002c26:	e822                	sd	s0,16(sp)
    80002c28:	e426                	sd	s1,8(sp)
    80002c2a:	e04a                	sd	s2,0(sp)
    80002c2c:	1000                	addi	s0,sp,32
    80002c2e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c30:	415c                	lw	a5,4(a0)
    80002c32:	0047d79b          	srliw	a5,a5,0x4
    80002c36:	00021597          	auipc	a1,0x21
    80002c3a:	b3a5a583          	lw	a1,-1222(a1) # 80023770 <sb+0x18>
    80002c3e:	9dbd                	addw	a1,a1,a5
    80002c40:	4108                	lw	a0,0(a0)
    80002c42:	00000097          	auipc	ra,0x0
    80002c46:	8aa080e7          	jalr	-1878(ra) # 800024ec <bread>
    80002c4a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c4c:	05850793          	addi	a5,a0,88
    80002c50:	40d8                	lw	a4,4(s1)
    80002c52:	8b3d                	andi	a4,a4,15
    80002c54:	071a                	slli	a4,a4,0x6
    80002c56:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c58:	04449703          	lh	a4,68(s1)
    80002c5c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c60:	04649703          	lh	a4,70(s1)
    80002c64:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002c68:	04849703          	lh	a4,72(s1)
    80002c6c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c70:	04a49703          	lh	a4,74(s1)
    80002c74:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c78:	44f8                	lw	a4,76(s1)
    80002c7a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c7c:	03400613          	li	a2,52
    80002c80:	05048593          	addi	a1,s1,80
    80002c84:	00c78513          	addi	a0,a5,12
    80002c88:	ffffd097          	auipc	ra,0xffffd
    80002c8c:	54e080e7          	jalr	1358(ra) # 800001d6 <memmove>
  log_write(bp);
    80002c90:	854a                	mv	a0,s2
    80002c92:	00001097          	auipc	ra,0x1
    80002c96:	c0e080e7          	jalr	-1010(ra) # 800038a0 <log_write>
  brelse(bp);
    80002c9a:	854a                	mv	a0,s2
    80002c9c:	00000097          	auipc	ra,0x0
    80002ca0:	980080e7          	jalr	-1664(ra) # 8000261c <brelse>
}
    80002ca4:	60e2                	ld	ra,24(sp)
    80002ca6:	6442                	ld	s0,16(sp)
    80002ca8:	64a2                	ld	s1,8(sp)
    80002caa:	6902                	ld	s2,0(sp)
    80002cac:	6105                	addi	sp,sp,32
    80002cae:	8082                	ret

0000000080002cb0 <idup>:
{
    80002cb0:	1101                	addi	sp,sp,-32
    80002cb2:	ec06                	sd	ra,24(sp)
    80002cb4:	e822                	sd	s0,16(sp)
    80002cb6:	e426                	sd	s1,8(sp)
    80002cb8:	1000                	addi	s0,sp,32
    80002cba:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cbc:	00021517          	auipc	a0,0x21
    80002cc0:	abc50513          	addi	a0,a0,-1348 # 80023778 <itable>
    80002cc4:	00004097          	auipc	ra,0x4
    80002cc8:	966080e7          	jalr	-1690(ra) # 8000662a <acquire>
  ip->ref++;
    80002ccc:	449c                	lw	a5,8(s1)
    80002cce:	2785                	addiw	a5,a5,1
    80002cd0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cd2:	00021517          	auipc	a0,0x21
    80002cd6:	aa650513          	addi	a0,a0,-1370 # 80023778 <itable>
    80002cda:	00004097          	auipc	ra,0x4
    80002cde:	a04080e7          	jalr	-1532(ra) # 800066de <release>
}
    80002ce2:	8526                	mv	a0,s1
    80002ce4:	60e2                	ld	ra,24(sp)
    80002ce6:	6442                	ld	s0,16(sp)
    80002ce8:	64a2                	ld	s1,8(sp)
    80002cea:	6105                	addi	sp,sp,32
    80002cec:	8082                	ret

0000000080002cee <ilock>:
{
    80002cee:	1101                	addi	sp,sp,-32
    80002cf0:	ec06                	sd	ra,24(sp)
    80002cf2:	e822                	sd	s0,16(sp)
    80002cf4:	e426                	sd	s1,8(sp)
    80002cf6:	e04a                	sd	s2,0(sp)
    80002cf8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002cfa:	c115                	beqz	a0,80002d1e <ilock+0x30>
    80002cfc:	84aa                	mv	s1,a0
    80002cfe:	451c                	lw	a5,8(a0)
    80002d00:	00f05f63          	blez	a5,80002d1e <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d04:	0541                	addi	a0,a0,16
    80002d06:	00001097          	auipc	ra,0x1
    80002d0a:	cb8080e7          	jalr	-840(ra) # 800039be <acquiresleep>
  if(ip->valid == 0){
    80002d0e:	40bc                	lw	a5,64(s1)
    80002d10:	cf99                	beqz	a5,80002d2e <ilock+0x40>
}
    80002d12:	60e2                	ld	ra,24(sp)
    80002d14:	6442                	ld	s0,16(sp)
    80002d16:	64a2                	ld	s1,8(sp)
    80002d18:	6902                	ld	s2,0(sp)
    80002d1a:	6105                	addi	sp,sp,32
    80002d1c:	8082                	ret
    panic("ilock");
    80002d1e:	00006517          	auipc	a0,0x6
    80002d22:	85250513          	addi	a0,a0,-1966 # 80008570 <syscalls+0x190>
    80002d26:	00003097          	auipc	ra,0x3
    80002d2a:	3cc080e7          	jalr	972(ra) # 800060f2 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d2e:	40dc                	lw	a5,4(s1)
    80002d30:	0047d79b          	srliw	a5,a5,0x4
    80002d34:	00021597          	auipc	a1,0x21
    80002d38:	a3c5a583          	lw	a1,-1476(a1) # 80023770 <sb+0x18>
    80002d3c:	9dbd                	addw	a1,a1,a5
    80002d3e:	4088                	lw	a0,0(s1)
    80002d40:	fffff097          	auipc	ra,0xfffff
    80002d44:	7ac080e7          	jalr	1964(ra) # 800024ec <bread>
    80002d48:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d4a:	05850593          	addi	a1,a0,88
    80002d4e:	40dc                	lw	a5,4(s1)
    80002d50:	8bbd                	andi	a5,a5,15
    80002d52:	079a                	slli	a5,a5,0x6
    80002d54:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d56:	00059783          	lh	a5,0(a1)
    80002d5a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d5e:	00259783          	lh	a5,2(a1)
    80002d62:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d66:	00459783          	lh	a5,4(a1)
    80002d6a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d6e:	00659783          	lh	a5,6(a1)
    80002d72:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d76:	459c                	lw	a5,8(a1)
    80002d78:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d7a:	03400613          	li	a2,52
    80002d7e:	05b1                	addi	a1,a1,12
    80002d80:	05048513          	addi	a0,s1,80
    80002d84:	ffffd097          	auipc	ra,0xffffd
    80002d88:	452080e7          	jalr	1106(ra) # 800001d6 <memmove>
    brelse(bp);
    80002d8c:	854a                	mv	a0,s2
    80002d8e:	00000097          	auipc	ra,0x0
    80002d92:	88e080e7          	jalr	-1906(ra) # 8000261c <brelse>
    ip->valid = 1;
    80002d96:	4785                	li	a5,1
    80002d98:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d9a:	04449783          	lh	a5,68(s1)
    80002d9e:	fbb5                	bnez	a5,80002d12 <ilock+0x24>
      panic("ilock: no type");
    80002da0:	00005517          	auipc	a0,0x5
    80002da4:	7d850513          	addi	a0,a0,2008 # 80008578 <syscalls+0x198>
    80002da8:	00003097          	auipc	ra,0x3
    80002dac:	34a080e7          	jalr	842(ra) # 800060f2 <panic>

0000000080002db0 <iunlock>:
{
    80002db0:	1101                	addi	sp,sp,-32
    80002db2:	ec06                	sd	ra,24(sp)
    80002db4:	e822                	sd	s0,16(sp)
    80002db6:	e426                	sd	s1,8(sp)
    80002db8:	e04a                	sd	s2,0(sp)
    80002dba:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002dbc:	c905                	beqz	a0,80002dec <iunlock+0x3c>
    80002dbe:	84aa                	mv	s1,a0
    80002dc0:	01050913          	addi	s2,a0,16
    80002dc4:	854a                	mv	a0,s2
    80002dc6:	00001097          	auipc	ra,0x1
    80002dca:	c94080e7          	jalr	-876(ra) # 80003a5a <holdingsleep>
    80002dce:	cd19                	beqz	a0,80002dec <iunlock+0x3c>
    80002dd0:	449c                	lw	a5,8(s1)
    80002dd2:	00f05d63          	blez	a5,80002dec <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002dd6:	854a                	mv	a0,s2
    80002dd8:	00001097          	auipc	ra,0x1
    80002ddc:	c3e080e7          	jalr	-962(ra) # 80003a16 <releasesleep>
}
    80002de0:	60e2                	ld	ra,24(sp)
    80002de2:	6442                	ld	s0,16(sp)
    80002de4:	64a2                	ld	s1,8(sp)
    80002de6:	6902                	ld	s2,0(sp)
    80002de8:	6105                	addi	sp,sp,32
    80002dea:	8082                	ret
    panic("iunlock");
    80002dec:	00005517          	auipc	a0,0x5
    80002df0:	79c50513          	addi	a0,a0,1948 # 80008588 <syscalls+0x1a8>
    80002df4:	00003097          	auipc	ra,0x3
    80002df8:	2fe080e7          	jalr	766(ra) # 800060f2 <panic>

0000000080002dfc <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002dfc:	7179                	addi	sp,sp,-48
    80002dfe:	f406                	sd	ra,40(sp)
    80002e00:	f022                	sd	s0,32(sp)
    80002e02:	ec26                	sd	s1,24(sp)
    80002e04:	e84a                	sd	s2,16(sp)
    80002e06:	e44e                	sd	s3,8(sp)
    80002e08:	e052                	sd	s4,0(sp)
    80002e0a:	1800                	addi	s0,sp,48
    80002e0c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e0e:	05050493          	addi	s1,a0,80
    80002e12:	08050913          	addi	s2,a0,128
    80002e16:	a021                	j	80002e1e <itrunc+0x22>
    80002e18:	0491                	addi	s1,s1,4
    80002e1a:	01248d63          	beq	s1,s2,80002e34 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e1e:	408c                	lw	a1,0(s1)
    80002e20:	dde5                	beqz	a1,80002e18 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e22:	0009a503          	lw	a0,0(s3)
    80002e26:	00000097          	auipc	ra,0x0
    80002e2a:	90c080e7          	jalr	-1780(ra) # 80002732 <bfree>
      ip->addrs[i] = 0;
    80002e2e:	0004a023          	sw	zero,0(s1)
    80002e32:	b7dd                	j	80002e18 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e34:	0809a583          	lw	a1,128(s3)
    80002e38:	e185                	bnez	a1,80002e58 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e3a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e3e:	854e                	mv	a0,s3
    80002e40:	00000097          	auipc	ra,0x0
    80002e44:	de2080e7          	jalr	-542(ra) # 80002c22 <iupdate>
}
    80002e48:	70a2                	ld	ra,40(sp)
    80002e4a:	7402                	ld	s0,32(sp)
    80002e4c:	64e2                	ld	s1,24(sp)
    80002e4e:	6942                	ld	s2,16(sp)
    80002e50:	69a2                	ld	s3,8(sp)
    80002e52:	6a02                	ld	s4,0(sp)
    80002e54:	6145                	addi	sp,sp,48
    80002e56:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e58:	0009a503          	lw	a0,0(s3)
    80002e5c:	fffff097          	auipc	ra,0xfffff
    80002e60:	690080e7          	jalr	1680(ra) # 800024ec <bread>
    80002e64:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e66:	05850493          	addi	s1,a0,88
    80002e6a:	45850913          	addi	s2,a0,1112
    80002e6e:	a021                	j	80002e76 <itrunc+0x7a>
    80002e70:	0491                	addi	s1,s1,4
    80002e72:	01248b63          	beq	s1,s2,80002e88 <itrunc+0x8c>
      if(a[j])
    80002e76:	408c                	lw	a1,0(s1)
    80002e78:	dde5                	beqz	a1,80002e70 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002e7a:	0009a503          	lw	a0,0(s3)
    80002e7e:	00000097          	auipc	ra,0x0
    80002e82:	8b4080e7          	jalr	-1868(ra) # 80002732 <bfree>
    80002e86:	b7ed                	j	80002e70 <itrunc+0x74>
    brelse(bp);
    80002e88:	8552                	mv	a0,s4
    80002e8a:	fffff097          	auipc	ra,0xfffff
    80002e8e:	792080e7          	jalr	1938(ra) # 8000261c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e92:	0809a583          	lw	a1,128(s3)
    80002e96:	0009a503          	lw	a0,0(s3)
    80002e9a:	00000097          	auipc	ra,0x0
    80002e9e:	898080e7          	jalr	-1896(ra) # 80002732 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ea2:	0809a023          	sw	zero,128(s3)
    80002ea6:	bf51                	j	80002e3a <itrunc+0x3e>

0000000080002ea8 <iput>:
{
    80002ea8:	1101                	addi	sp,sp,-32
    80002eaa:	ec06                	sd	ra,24(sp)
    80002eac:	e822                	sd	s0,16(sp)
    80002eae:	e426                	sd	s1,8(sp)
    80002eb0:	e04a                	sd	s2,0(sp)
    80002eb2:	1000                	addi	s0,sp,32
    80002eb4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002eb6:	00021517          	auipc	a0,0x21
    80002eba:	8c250513          	addi	a0,a0,-1854 # 80023778 <itable>
    80002ebe:	00003097          	auipc	ra,0x3
    80002ec2:	76c080e7          	jalr	1900(ra) # 8000662a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ec6:	4498                	lw	a4,8(s1)
    80002ec8:	4785                	li	a5,1
    80002eca:	02f70363          	beq	a4,a5,80002ef0 <iput+0x48>
  ip->ref--;
    80002ece:	449c                	lw	a5,8(s1)
    80002ed0:	37fd                	addiw	a5,a5,-1
    80002ed2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ed4:	00021517          	auipc	a0,0x21
    80002ed8:	8a450513          	addi	a0,a0,-1884 # 80023778 <itable>
    80002edc:	00004097          	auipc	ra,0x4
    80002ee0:	802080e7          	jalr	-2046(ra) # 800066de <release>
}
    80002ee4:	60e2                	ld	ra,24(sp)
    80002ee6:	6442                	ld	s0,16(sp)
    80002ee8:	64a2                	ld	s1,8(sp)
    80002eea:	6902                	ld	s2,0(sp)
    80002eec:	6105                	addi	sp,sp,32
    80002eee:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ef0:	40bc                	lw	a5,64(s1)
    80002ef2:	dff1                	beqz	a5,80002ece <iput+0x26>
    80002ef4:	04a49783          	lh	a5,74(s1)
    80002ef8:	fbf9                	bnez	a5,80002ece <iput+0x26>
    acquiresleep(&ip->lock);
    80002efa:	01048913          	addi	s2,s1,16
    80002efe:	854a                	mv	a0,s2
    80002f00:	00001097          	auipc	ra,0x1
    80002f04:	abe080e7          	jalr	-1346(ra) # 800039be <acquiresleep>
    release(&itable.lock);
    80002f08:	00021517          	auipc	a0,0x21
    80002f0c:	87050513          	addi	a0,a0,-1936 # 80023778 <itable>
    80002f10:	00003097          	auipc	ra,0x3
    80002f14:	7ce080e7          	jalr	1998(ra) # 800066de <release>
    itrunc(ip);
    80002f18:	8526                	mv	a0,s1
    80002f1a:	00000097          	auipc	ra,0x0
    80002f1e:	ee2080e7          	jalr	-286(ra) # 80002dfc <itrunc>
    ip->type = 0;
    80002f22:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f26:	8526                	mv	a0,s1
    80002f28:	00000097          	auipc	ra,0x0
    80002f2c:	cfa080e7          	jalr	-774(ra) # 80002c22 <iupdate>
    ip->valid = 0;
    80002f30:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f34:	854a                	mv	a0,s2
    80002f36:	00001097          	auipc	ra,0x1
    80002f3a:	ae0080e7          	jalr	-1312(ra) # 80003a16 <releasesleep>
    acquire(&itable.lock);
    80002f3e:	00021517          	auipc	a0,0x21
    80002f42:	83a50513          	addi	a0,a0,-1990 # 80023778 <itable>
    80002f46:	00003097          	auipc	ra,0x3
    80002f4a:	6e4080e7          	jalr	1764(ra) # 8000662a <acquire>
    80002f4e:	b741                	j	80002ece <iput+0x26>

0000000080002f50 <iunlockput>:
{
    80002f50:	1101                	addi	sp,sp,-32
    80002f52:	ec06                	sd	ra,24(sp)
    80002f54:	e822                	sd	s0,16(sp)
    80002f56:	e426                	sd	s1,8(sp)
    80002f58:	1000                	addi	s0,sp,32
    80002f5a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f5c:	00000097          	auipc	ra,0x0
    80002f60:	e54080e7          	jalr	-428(ra) # 80002db0 <iunlock>
  iput(ip);
    80002f64:	8526                	mv	a0,s1
    80002f66:	00000097          	auipc	ra,0x0
    80002f6a:	f42080e7          	jalr	-190(ra) # 80002ea8 <iput>
}
    80002f6e:	60e2                	ld	ra,24(sp)
    80002f70:	6442                	ld	s0,16(sp)
    80002f72:	64a2                	ld	s1,8(sp)
    80002f74:	6105                	addi	sp,sp,32
    80002f76:	8082                	ret

0000000080002f78 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f78:	1141                	addi	sp,sp,-16
    80002f7a:	e422                	sd	s0,8(sp)
    80002f7c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f7e:	411c                	lw	a5,0(a0)
    80002f80:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f82:	415c                	lw	a5,4(a0)
    80002f84:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f86:	04451783          	lh	a5,68(a0)
    80002f8a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f8e:	04a51783          	lh	a5,74(a0)
    80002f92:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f96:	04c56783          	lwu	a5,76(a0)
    80002f9a:	e99c                	sd	a5,16(a1)
}
    80002f9c:	6422                	ld	s0,8(sp)
    80002f9e:	0141                	addi	sp,sp,16
    80002fa0:	8082                	ret

0000000080002fa2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fa2:	457c                	lw	a5,76(a0)
    80002fa4:	0ed7e963          	bltu	a5,a3,80003096 <readi+0xf4>
{
    80002fa8:	7159                	addi	sp,sp,-112
    80002faa:	f486                	sd	ra,104(sp)
    80002fac:	f0a2                	sd	s0,96(sp)
    80002fae:	eca6                	sd	s1,88(sp)
    80002fb0:	e8ca                	sd	s2,80(sp)
    80002fb2:	e4ce                	sd	s3,72(sp)
    80002fb4:	e0d2                	sd	s4,64(sp)
    80002fb6:	fc56                	sd	s5,56(sp)
    80002fb8:	f85a                	sd	s6,48(sp)
    80002fba:	f45e                	sd	s7,40(sp)
    80002fbc:	f062                	sd	s8,32(sp)
    80002fbe:	ec66                	sd	s9,24(sp)
    80002fc0:	e86a                	sd	s10,16(sp)
    80002fc2:	e46e                	sd	s11,8(sp)
    80002fc4:	1880                	addi	s0,sp,112
    80002fc6:	8baa                	mv	s7,a0
    80002fc8:	8c2e                	mv	s8,a1
    80002fca:	8ab2                	mv	s5,a2
    80002fcc:	84b6                	mv	s1,a3
    80002fce:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fd0:	9f35                	addw	a4,a4,a3
    return 0;
    80002fd2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002fd4:	0ad76063          	bltu	a4,a3,80003074 <readi+0xd2>
  if(off + n > ip->size)
    80002fd8:	00e7f463          	bgeu	a5,a4,80002fe0 <readi+0x3e>
    n = ip->size - off;
    80002fdc:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fe0:	0a0b0963          	beqz	s6,80003092 <readi+0xf0>
    80002fe4:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fe6:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002fea:	5cfd                	li	s9,-1
    80002fec:	a82d                	j	80003026 <readi+0x84>
    80002fee:	020a1d93          	slli	s11,s4,0x20
    80002ff2:	020ddd93          	srli	s11,s11,0x20
    80002ff6:	05890613          	addi	a2,s2,88
    80002ffa:	86ee                	mv	a3,s11
    80002ffc:	963a                	add	a2,a2,a4
    80002ffe:	85d6                	mv	a1,s5
    80003000:	8562                	mv	a0,s8
    80003002:	fffff097          	auipc	ra,0xfffff
    80003006:	9f2080e7          	jalr	-1550(ra) # 800019f4 <either_copyout>
    8000300a:	05950d63          	beq	a0,s9,80003064 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000300e:	854a                	mv	a0,s2
    80003010:	fffff097          	auipc	ra,0xfffff
    80003014:	60c080e7          	jalr	1548(ra) # 8000261c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003018:	013a09bb          	addw	s3,s4,s3
    8000301c:	009a04bb          	addw	s1,s4,s1
    80003020:	9aee                	add	s5,s5,s11
    80003022:	0569f763          	bgeu	s3,s6,80003070 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003026:	000ba903          	lw	s2,0(s7)
    8000302a:	00a4d59b          	srliw	a1,s1,0xa
    8000302e:	855e                	mv	a0,s7
    80003030:	00000097          	auipc	ra,0x0
    80003034:	8ac080e7          	jalr	-1876(ra) # 800028dc <bmap>
    80003038:	0005059b          	sext.w	a1,a0
    8000303c:	854a                	mv	a0,s2
    8000303e:	fffff097          	auipc	ra,0xfffff
    80003042:	4ae080e7          	jalr	1198(ra) # 800024ec <bread>
    80003046:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003048:	3ff4f713          	andi	a4,s1,1023
    8000304c:	40ed07bb          	subw	a5,s10,a4
    80003050:	413b06bb          	subw	a3,s6,s3
    80003054:	8a3e                	mv	s4,a5
    80003056:	2781                	sext.w	a5,a5
    80003058:	0006861b          	sext.w	a2,a3
    8000305c:	f8f679e3          	bgeu	a2,a5,80002fee <readi+0x4c>
    80003060:	8a36                	mv	s4,a3
    80003062:	b771                	j	80002fee <readi+0x4c>
      brelse(bp);
    80003064:	854a                	mv	a0,s2
    80003066:	fffff097          	auipc	ra,0xfffff
    8000306a:	5b6080e7          	jalr	1462(ra) # 8000261c <brelse>
      tot = -1;
    8000306e:	59fd                	li	s3,-1
  }
  return tot;
    80003070:	0009851b          	sext.w	a0,s3
}
    80003074:	70a6                	ld	ra,104(sp)
    80003076:	7406                	ld	s0,96(sp)
    80003078:	64e6                	ld	s1,88(sp)
    8000307a:	6946                	ld	s2,80(sp)
    8000307c:	69a6                	ld	s3,72(sp)
    8000307e:	6a06                	ld	s4,64(sp)
    80003080:	7ae2                	ld	s5,56(sp)
    80003082:	7b42                	ld	s6,48(sp)
    80003084:	7ba2                	ld	s7,40(sp)
    80003086:	7c02                	ld	s8,32(sp)
    80003088:	6ce2                	ld	s9,24(sp)
    8000308a:	6d42                	ld	s10,16(sp)
    8000308c:	6da2                	ld	s11,8(sp)
    8000308e:	6165                	addi	sp,sp,112
    80003090:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003092:	89da                	mv	s3,s6
    80003094:	bff1                	j	80003070 <readi+0xce>
    return 0;
    80003096:	4501                	li	a0,0
}
    80003098:	8082                	ret

000000008000309a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000309a:	457c                	lw	a5,76(a0)
    8000309c:	10d7e863          	bltu	a5,a3,800031ac <writei+0x112>
{
    800030a0:	7159                	addi	sp,sp,-112
    800030a2:	f486                	sd	ra,104(sp)
    800030a4:	f0a2                	sd	s0,96(sp)
    800030a6:	eca6                	sd	s1,88(sp)
    800030a8:	e8ca                	sd	s2,80(sp)
    800030aa:	e4ce                	sd	s3,72(sp)
    800030ac:	e0d2                	sd	s4,64(sp)
    800030ae:	fc56                	sd	s5,56(sp)
    800030b0:	f85a                	sd	s6,48(sp)
    800030b2:	f45e                	sd	s7,40(sp)
    800030b4:	f062                	sd	s8,32(sp)
    800030b6:	ec66                	sd	s9,24(sp)
    800030b8:	e86a                	sd	s10,16(sp)
    800030ba:	e46e                	sd	s11,8(sp)
    800030bc:	1880                	addi	s0,sp,112
    800030be:	8b2a                	mv	s6,a0
    800030c0:	8c2e                	mv	s8,a1
    800030c2:	8ab2                	mv	s5,a2
    800030c4:	8936                	mv	s2,a3
    800030c6:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800030c8:	00e687bb          	addw	a5,a3,a4
    800030cc:	0ed7e263          	bltu	a5,a3,800031b0 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030d0:	00043737          	lui	a4,0x43
    800030d4:	0ef76063          	bltu	a4,a5,800031b4 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030d8:	0c0b8863          	beqz	s7,800031a8 <writei+0x10e>
    800030dc:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030de:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800030e2:	5cfd                	li	s9,-1
    800030e4:	a091                	j	80003128 <writei+0x8e>
    800030e6:	02099d93          	slli	s11,s3,0x20
    800030ea:	020ddd93          	srli	s11,s11,0x20
    800030ee:	05848513          	addi	a0,s1,88
    800030f2:	86ee                	mv	a3,s11
    800030f4:	8656                	mv	a2,s5
    800030f6:	85e2                	mv	a1,s8
    800030f8:	953a                	add	a0,a0,a4
    800030fa:	fffff097          	auipc	ra,0xfffff
    800030fe:	952080e7          	jalr	-1710(ra) # 80001a4c <either_copyin>
    80003102:	07950263          	beq	a0,s9,80003166 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003106:	8526                	mv	a0,s1
    80003108:	00000097          	auipc	ra,0x0
    8000310c:	798080e7          	jalr	1944(ra) # 800038a0 <log_write>
    brelse(bp);
    80003110:	8526                	mv	a0,s1
    80003112:	fffff097          	auipc	ra,0xfffff
    80003116:	50a080e7          	jalr	1290(ra) # 8000261c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000311a:	01498a3b          	addw	s4,s3,s4
    8000311e:	0129893b          	addw	s2,s3,s2
    80003122:	9aee                	add	s5,s5,s11
    80003124:	057a7663          	bgeu	s4,s7,80003170 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003128:	000b2483          	lw	s1,0(s6)
    8000312c:	00a9559b          	srliw	a1,s2,0xa
    80003130:	855a                	mv	a0,s6
    80003132:	fffff097          	auipc	ra,0xfffff
    80003136:	7aa080e7          	jalr	1962(ra) # 800028dc <bmap>
    8000313a:	0005059b          	sext.w	a1,a0
    8000313e:	8526                	mv	a0,s1
    80003140:	fffff097          	auipc	ra,0xfffff
    80003144:	3ac080e7          	jalr	940(ra) # 800024ec <bread>
    80003148:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000314a:	3ff97713          	andi	a4,s2,1023
    8000314e:	40ed07bb          	subw	a5,s10,a4
    80003152:	414b86bb          	subw	a3,s7,s4
    80003156:	89be                	mv	s3,a5
    80003158:	2781                	sext.w	a5,a5
    8000315a:	0006861b          	sext.w	a2,a3
    8000315e:	f8f674e3          	bgeu	a2,a5,800030e6 <writei+0x4c>
    80003162:	89b6                	mv	s3,a3
    80003164:	b749                	j	800030e6 <writei+0x4c>
      brelse(bp);
    80003166:	8526                	mv	a0,s1
    80003168:	fffff097          	auipc	ra,0xfffff
    8000316c:	4b4080e7          	jalr	1204(ra) # 8000261c <brelse>
  }

  if(off > ip->size)
    80003170:	04cb2783          	lw	a5,76(s6)
    80003174:	0127f463          	bgeu	a5,s2,8000317c <writei+0xe2>
    ip->size = off;
    80003178:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000317c:	855a                	mv	a0,s6
    8000317e:	00000097          	auipc	ra,0x0
    80003182:	aa4080e7          	jalr	-1372(ra) # 80002c22 <iupdate>

  return tot;
    80003186:	000a051b          	sext.w	a0,s4
}
    8000318a:	70a6                	ld	ra,104(sp)
    8000318c:	7406                	ld	s0,96(sp)
    8000318e:	64e6                	ld	s1,88(sp)
    80003190:	6946                	ld	s2,80(sp)
    80003192:	69a6                	ld	s3,72(sp)
    80003194:	6a06                	ld	s4,64(sp)
    80003196:	7ae2                	ld	s5,56(sp)
    80003198:	7b42                	ld	s6,48(sp)
    8000319a:	7ba2                	ld	s7,40(sp)
    8000319c:	7c02                	ld	s8,32(sp)
    8000319e:	6ce2                	ld	s9,24(sp)
    800031a0:	6d42                	ld	s10,16(sp)
    800031a2:	6da2                	ld	s11,8(sp)
    800031a4:	6165                	addi	sp,sp,112
    800031a6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031a8:	8a5e                	mv	s4,s7
    800031aa:	bfc9                	j	8000317c <writei+0xe2>
    return -1;
    800031ac:	557d                	li	a0,-1
}
    800031ae:	8082                	ret
    return -1;
    800031b0:	557d                	li	a0,-1
    800031b2:	bfe1                	j	8000318a <writei+0xf0>
    return -1;
    800031b4:	557d                	li	a0,-1
    800031b6:	bfd1                	j	8000318a <writei+0xf0>

00000000800031b8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031b8:	1141                	addi	sp,sp,-16
    800031ba:	e406                	sd	ra,8(sp)
    800031bc:	e022                	sd	s0,0(sp)
    800031be:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031c0:	4639                	li	a2,14
    800031c2:	ffffd097          	auipc	ra,0xffffd
    800031c6:	088080e7          	jalr	136(ra) # 8000024a <strncmp>
}
    800031ca:	60a2                	ld	ra,8(sp)
    800031cc:	6402                	ld	s0,0(sp)
    800031ce:	0141                	addi	sp,sp,16
    800031d0:	8082                	ret

00000000800031d2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031d2:	7139                	addi	sp,sp,-64
    800031d4:	fc06                	sd	ra,56(sp)
    800031d6:	f822                	sd	s0,48(sp)
    800031d8:	f426                	sd	s1,40(sp)
    800031da:	f04a                	sd	s2,32(sp)
    800031dc:	ec4e                	sd	s3,24(sp)
    800031de:	e852                	sd	s4,16(sp)
    800031e0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800031e2:	04451703          	lh	a4,68(a0)
    800031e6:	4785                	li	a5,1
    800031e8:	00f71a63          	bne	a4,a5,800031fc <dirlookup+0x2a>
    800031ec:	892a                	mv	s2,a0
    800031ee:	89ae                	mv	s3,a1
    800031f0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031f2:	457c                	lw	a5,76(a0)
    800031f4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031f6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031f8:	e79d                	bnez	a5,80003226 <dirlookup+0x54>
    800031fa:	a8a5                	j	80003272 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031fc:	00005517          	auipc	a0,0x5
    80003200:	39450513          	addi	a0,a0,916 # 80008590 <syscalls+0x1b0>
    80003204:	00003097          	auipc	ra,0x3
    80003208:	eee080e7          	jalr	-274(ra) # 800060f2 <panic>
      panic("dirlookup read");
    8000320c:	00005517          	auipc	a0,0x5
    80003210:	39c50513          	addi	a0,a0,924 # 800085a8 <syscalls+0x1c8>
    80003214:	00003097          	auipc	ra,0x3
    80003218:	ede080e7          	jalr	-290(ra) # 800060f2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000321c:	24c1                	addiw	s1,s1,16
    8000321e:	04c92783          	lw	a5,76(s2)
    80003222:	04f4f763          	bgeu	s1,a5,80003270 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003226:	4741                	li	a4,16
    80003228:	86a6                	mv	a3,s1
    8000322a:	fc040613          	addi	a2,s0,-64
    8000322e:	4581                	li	a1,0
    80003230:	854a                	mv	a0,s2
    80003232:	00000097          	auipc	ra,0x0
    80003236:	d70080e7          	jalr	-656(ra) # 80002fa2 <readi>
    8000323a:	47c1                	li	a5,16
    8000323c:	fcf518e3          	bne	a0,a5,8000320c <dirlookup+0x3a>
    if(de.inum == 0)
    80003240:	fc045783          	lhu	a5,-64(s0)
    80003244:	dfe1                	beqz	a5,8000321c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003246:	fc240593          	addi	a1,s0,-62
    8000324a:	854e                	mv	a0,s3
    8000324c:	00000097          	auipc	ra,0x0
    80003250:	f6c080e7          	jalr	-148(ra) # 800031b8 <namecmp>
    80003254:	f561                	bnez	a0,8000321c <dirlookup+0x4a>
      if(poff)
    80003256:	000a0463          	beqz	s4,8000325e <dirlookup+0x8c>
        *poff = off;
    8000325a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000325e:	fc045583          	lhu	a1,-64(s0)
    80003262:	00092503          	lw	a0,0(s2)
    80003266:	fffff097          	auipc	ra,0xfffff
    8000326a:	752080e7          	jalr	1874(ra) # 800029b8 <iget>
    8000326e:	a011                	j	80003272 <dirlookup+0xa0>
  return 0;
    80003270:	4501                	li	a0,0
}
    80003272:	70e2                	ld	ra,56(sp)
    80003274:	7442                	ld	s0,48(sp)
    80003276:	74a2                	ld	s1,40(sp)
    80003278:	7902                	ld	s2,32(sp)
    8000327a:	69e2                	ld	s3,24(sp)
    8000327c:	6a42                	ld	s4,16(sp)
    8000327e:	6121                	addi	sp,sp,64
    80003280:	8082                	ret

0000000080003282 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003282:	711d                	addi	sp,sp,-96
    80003284:	ec86                	sd	ra,88(sp)
    80003286:	e8a2                	sd	s0,80(sp)
    80003288:	e4a6                	sd	s1,72(sp)
    8000328a:	e0ca                	sd	s2,64(sp)
    8000328c:	fc4e                	sd	s3,56(sp)
    8000328e:	f852                	sd	s4,48(sp)
    80003290:	f456                	sd	s5,40(sp)
    80003292:	f05a                	sd	s6,32(sp)
    80003294:	ec5e                	sd	s7,24(sp)
    80003296:	e862                	sd	s8,16(sp)
    80003298:	e466                	sd	s9,8(sp)
    8000329a:	e06a                	sd	s10,0(sp)
    8000329c:	1080                	addi	s0,sp,96
    8000329e:	84aa                	mv	s1,a0
    800032a0:	8b2e                	mv	s6,a1
    800032a2:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032a4:	00054703          	lbu	a4,0(a0)
    800032a8:	02f00793          	li	a5,47
    800032ac:	02f70363          	beq	a4,a5,800032d2 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032b0:	ffffe097          	auipc	ra,0xffffe
    800032b4:	b96080e7          	jalr	-1130(ra) # 80000e46 <myproc>
    800032b8:	45853503          	ld	a0,1112(a0)
    800032bc:	00000097          	auipc	ra,0x0
    800032c0:	9f4080e7          	jalr	-1548(ra) # 80002cb0 <idup>
    800032c4:	8a2a                	mv	s4,a0
  while(*path == '/')
    800032c6:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800032ca:	4cb5                	li	s9,13
  len = path - s;
    800032cc:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032ce:	4c05                	li	s8,1
    800032d0:	a87d                	j	8000338e <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800032d2:	4585                	li	a1,1
    800032d4:	4505                	li	a0,1
    800032d6:	fffff097          	auipc	ra,0xfffff
    800032da:	6e2080e7          	jalr	1762(ra) # 800029b8 <iget>
    800032de:	8a2a                	mv	s4,a0
    800032e0:	b7dd                	j	800032c6 <namex+0x44>
      iunlockput(ip);
    800032e2:	8552                	mv	a0,s4
    800032e4:	00000097          	auipc	ra,0x0
    800032e8:	c6c080e7          	jalr	-916(ra) # 80002f50 <iunlockput>
      return 0;
    800032ec:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032ee:	8552                	mv	a0,s4
    800032f0:	60e6                	ld	ra,88(sp)
    800032f2:	6446                	ld	s0,80(sp)
    800032f4:	64a6                	ld	s1,72(sp)
    800032f6:	6906                	ld	s2,64(sp)
    800032f8:	79e2                	ld	s3,56(sp)
    800032fa:	7a42                	ld	s4,48(sp)
    800032fc:	7aa2                	ld	s5,40(sp)
    800032fe:	7b02                	ld	s6,32(sp)
    80003300:	6be2                	ld	s7,24(sp)
    80003302:	6c42                	ld	s8,16(sp)
    80003304:	6ca2                	ld	s9,8(sp)
    80003306:	6d02                	ld	s10,0(sp)
    80003308:	6125                	addi	sp,sp,96
    8000330a:	8082                	ret
      iunlock(ip);
    8000330c:	8552                	mv	a0,s4
    8000330e:	00000097          	auipc	ra,0x0
    80003312:	aa2080e7          	jalr	-1374(ra) # 80002db0 <iunlock>
      return ip;
    80003316:	bfe1                	j	800032ee <namex+0x6c>
      iunlockput(ip);
    80003318:	8552                	mv	a0,s4
    8000331a:	00000097          	auipc	ra,0x0
    8000331e:	c36080e7          	jalr	-970(ra) # 80002f50 <iunlockput>
      return 0;
    80003322:	8a4e                	mv	s4,s3
    80003324:	b7e9                	j	800032ee <namex+0x6c>
  len = path - s;
    80003326:	40998633          	sub	a2,s3,s1
    8000332a:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000332e:	09acd863          	bge	s9,s10,800033be <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003332:	4639                	li	a2,14
    80003334:	85a6                	mv	a1,s1
    80003336:	8556                	mv	a0,s5
    80003338:	ffffd097          	auipc	ra,0xffffd
    8000333c:	e9e080e7          	jalr	-354(ra) # 800001d6 <memmove>
    80003340:	84ce                	mv	s1,s3
  while(*path == '/')
    80003342:	0004c783          	lbu	a5,0(s1)
    80003346:	01279763          	bne	a5,s2,80003354 <namex+0xd2>
    path++;
    8000334a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000334c:	0004c783          	lbu	a5,0(s1)
    80003350:	ff278de3          	beq	a5,s2,8000334a <namex+0xc8>
    ilock(ip);
    80003354:	8552                	mv	a0,s4
    80003356:	00000097          	auipc	ra,0x0
    8000335a:	998080e7          	jalr	-1640(ra) # 80002cee <ilock>
    if(ip->type != T_DIR){
    8000335e:	044a1783          	lh	a5,68(s4)
    80003362:	f98790e3          	bne	a5,s8,800032e2 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003366:	000b0563          	beqz	s6,80003370 <namex+0xee>
    8000336a:	0004c783          	lbu	a5,0(s1)
    8000336e:	dfd9                	beqz	a5,8000330c <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003370:	865e                	mv	a2,s7
    80003372:	85d6                	mv	a1,s5
    80003374:	8552                	mv	a0,s4
    80003376:	00000097          	auipc	ra,0x0
    8000337a:	e5c080e7          	jalr	-420(ra) # 800031d2 <dirlookup>
    8000337e:	89aa                	mv	s3,a0
    80003380:	dd41                	beqz	a0,80003318 <namex+0x96>
    iunlockput(ip);
    80003382:	8552                	mv	a0,s4
    80003384:	00000097          	auipc	ra,0x0
    80003388:	bcc080e7          	jalr	-1076(ra) # 80002f50 <iunlockput>
    ip = next;
    8000338c:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000338e:	0004c783          	lbu	a5,0(s1)
    80003392:	01279763          	bne	a5,s2,800033a0 <namex+0x11e>
    path++;
    80003396:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003398:	0004c783          	lbu	a5,0(s1)
    8000339c:	ff278de3          	beq	a5,s2,80003396 <namex+0x114>
  if(*path == 0)
    800033a0:	cb9d                	beqz	a5,800033d6 <namex+0x154>
  while(*path != '/' && *path != 0)
    800033a2:	0004c783          	lbu	a5,0(s1)
    800033a6:	89a6                	mv	s3,s1
  len = path - s;
    800033a8:	8d5e                	mv	s10,s7
    800033aa:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800033ac:	01278963          	beq	a5,s2,800033be <namex+0x13c>
    800033b0:	dbbd                	beqz	a5,80003326 <namex+0xa4>
    path++;
    800033b2:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800033b4:	0009c783          	lbu	a5,0(s3)
    800033b8:	ff279ce3          	bne	a5,s2,800033b0 <namex+0x12e>
    800033bc:	b7ad                	j	80003326 <namex+0xa4>
    memmove(name, s, len);
    800033be:	2601                	sext.w	a2,a2
    800033c0:	85a6                	mv	a1,s1
    800033c2:	8556                	mv	a0,s5
    800033c4:	ffffd097          	auipc	ra,0xffffd
    800033c8:	e12080e7          	jalr	-494(ra) # 800001d6 <memmove>
    name[len] = 0;
    800033cc:	9d56                	add	s10,s10,s5
    800033ce:	000d0023          	sb	zero,0(s10)
    800033d2:	84ce                	mv	s1,s3
    800033d4:	b7bd                	j	80003342 <namex+0xc0>
  if(nameiparent){
    800033d6:	f00b0ce3          	beqz	s6,800032ee <namex+0x6c>
    iput(ip);
    800033da:	8552                	mv	a0,s4
    800033dc:	00000097          	auipc	ra,0x0
    800033e0:	acc080e7          	jalr	-1332(ra) # 80002ea8 <iput>
    return 0;
    800033e4:	4a01                	li	s4,0
    800033e6:	b721                	j	800032ee <namex+0x6c>

00000000800033e8 <dirlink>:
{
    800033e8:	7139                	addi	sp,sp,-64
    800033ea:	fc06                	sd	ra,56(sp)
    800033ec:	f822                	sd	s0,48(sp)
    800033ee:	f426                	sd	s1,40(sp)
    800033f0:	f04a                	sd	s2,32(sp)
    800033f2:	ec4e                	sd	s3,24(sp)
    800033f4:	e852                	sd	s4,16(sp)
    800033f6:	0080                	addi	s0,sp,64
    800033f8:	892a                	mv	s2,a0
    800033fa:	8a2e                	mv	s4,a1
    800033fc:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033fe:	4601                	li	a2,0
    80003400:	00000097          	auipc	ra,0x0
    80003404:	dd2080e7          	jalr	-558(ra) # 800031d2 <dirlookup>
    80003408:	e93d                	bnez	a0,8000347e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000340a:	04c92483          	lw	s1,76(s2)
    8000340e:	c49d                	beqz	s1,8000343c <dirlink+0x54>
    80003410:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003412:	4741                	li	a4,16
    80003414:	86a6                	mv	a3,s1
    80003416:	fc040613          	addi	a2,s0,-64
    8000341a:	4581                	li	a1,0
    8000341c:	854a                	mv	a0,s2
    8000341e:	00000097          	auipc	ra,0x0
    80003422:	b84080e7          	jalr	-1148(ra) # 80002fa2 <readi>
    80003426:	47c1                	li	a5,16
    80003428:	06f51163          	bne	a0,a5,8000348a <dirlink+0xa2>
    if(de.inum == 0)
    8000342c:	fc045783          	lhu	a5,-64(s0)
    80003430:	c791                	beqz	a5,8000343c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003432:	24c1                	addiw	s1,s1,16
    80003434:	04c92783          	lw	a5,76(s2)
    80003438:	fcf4ede3          	bltu	s1,a5,80003412 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000343c:	4639                	li	a2,14
    8000343e:	85d2                	mv	a1,s4
    80003440:	fc240513          	addi	a0,s0,-62
    80003444:	ffffd097          	auipc	ra,0xffffd
    80003448:	e42080e7          	jalr	-446(ra) # 80000286 <strncpy>
  de.inum = inum;
    8000344c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003450:	4741                	li	a4,16
    80003452:	86a6                	mv	a3,s1
    80003454:	fc040613          	addi	a2,s0,-64
    80003458:	4581                	li	a1,0
    8000345a:	854a                	mv	a0,s2
    8000345c:	00000097          	auipc	ra,0x0
    80003460:	c3e080e7          	jalr	-962(ra) # 8000309a <writei>
    80003464:	872a                	mv	a4,a0
    80003466:	47c1                	li	a5,16
  return 0;
    80003468:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000346a:	02f71863          	bne	a4,a5,8000349a <dirlink+0xb2>
}
    8000346e:	70e2                	ld	ra,56(sp)
    80003470:	7442                	ld	s0,48(sp)
    80003472:	74a2                	ld	s1,40(sp)
    80003474:	7902                	ld	s2,32(sp)
    80003476:	69e2                	ld	s3,24(sp)
    80003478:	6a42                	ld	s4,16(sp)
    8000347a:	6121                	addi	sp,sp,64
    8000347c:	8082                	ret
    iput(ip);
    8000347e:	00000097          	auipc	ra,0x0
    80003482:	a2a080e7          	jalr	-1494(ra) # 80002ea8 <iput>
    return -1;
    80003486:	557d                	li	a0,-1
    80003488:	b7dd                	j	8000346e <dirlink+0x86>
      panic("dirlink read");
    8000348a:	00005517          	auipc	a0,0x5
    8000348e:	12e50513          	addi	a0,a0,302 # 800085b8 <syscalls+0x1d8>
    80003492:	00003097          	auipc	ra,0x3
    80003496:	c60080e7          	jalr	-928(ra) # 800060f2 <panic>
    panic("dirlink");
    8000349a:	00005517          	auipc	a0,0x5
    8000349e:	23e50513          	addi	a0,a0,574 # 800086d8 <syscalls+0x2f8>
    800034a2:	00003097          	auipc	ra,0x3
    800034a6:	c50080e7          	jalr	-944(ra) # 800060f2 <panic>

00000000800034aa <namei>:

struct inode*
namei(char *path)
{
    800034aa:	1101                	addi	sp,sp,-32
    800034ac:	ec06                	sd	ra,24(sp)
    800034ae:	e822                	sd	s0,16(sp)
    800034b0:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034b2:	fe040613          	addi	a2,s0,-32
    800034b6:	4581                	li	a1,0
    800034b8:	00000097          	auipc	ra,0x0
    800034bc:	dca080e7          	jalr	-566(ra) # 80003282 <namex>
}
    800034c0:	60e2                	ld	ra,24(sp)
    800034c2:	6442                	ld	s0,16(sp)
    800034c4:	6105                	addi	sp,sp,32
    800034c6:	8082                	ret

00000000800034c8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034c8:	1141                	addi	sp,sp,-16
    800034ca:	e406                	sd	ra,8(sp)
    800034cc:	e022                	sd	s0,0(sp)
    800034ce:	0800                	addi	s0,sp,16
    800034d0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034d2:	4585                	li	a1,1
    800034d4:	00000097          	auipc	ra,0x0
    800034d8:	dae080e7          	jalr	-594(ra) # 80003282 <namex>
}
    800034dc:	60a2                	ld	ra,8(sp)
    800034de:	6402                	ld	s0,0(sp)
    800034e0:	0141                	addi	sp,sp,16
    800034e2:	8082                	ret

00000000800034e4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034e4:	1101                	addi	sp,sp,-32
    800034e6:	ec06                	sd	ra,24(sp)
    800034e8:	e822                	sd	s0,16(sp)
    800034ea:	e426                	sd	s1,8(sp)
    800034ec:	e04a                	sd	s2,0(sp)
    800034ee:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034f0:	00022917          	auipc	s2,0x22
    800034f4:	d3090913          	addi	s2,s2,-720 # 80025220 <log>
    800034f8:	01892583          	lw	a1,24(s2)
    800034fc:	02892503          	lw	a0,40(s2)
    80003500:	fffff097          	auipc	ra,0xfffff
    80003504:	fec080e7          	jalr	-20(ra) # 800024ec <bread>
    80003508:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000350a:	02c92683          	lw	a3,44(s2)
    8000350e:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003510:	02d05863          	blez	a3,80003540 <write_head+0x5c>
    80003514:	00022797          	auipc	a5,0x22
    80003518:	d3c78793          	addi	a5,a5,-708 # 80025250 <log+0x30>
    8000351c:	05c50713          	addi	a4,a0,92
    80003520:	36fd                	addiw	a3,a3,-1
    80003522:	02069613          	slli	a2,a3,0x20
    80003526:	01e65693          	srli	a3,a2,0x1e
    8000352a:	00022617          	auipc	a2,0x22
    8000352e:	d2a60613          	addi	a2,a2,-726 # 80025254 <log+0x34>
    80003532:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003534:	4390                	lw	a2,0(a5)
    80003536:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003538:	0791                	addi	a5,a5,4
    8000353a:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000353c:	fed79ce3          	bne	a5,a3,80003534 <write_head+0x50>
  }
  bwrite(buf);
    80003540:	8526                	mv	a0,s1
    80003542:	fffff097          	auipc	ra,0xfffff
    80003546:	09c080e7          	jalr	156(ra) # 800025de <bwrite>
  brelse(buf);
    8000354a:	8526                	mv	a0,s1
    8000354c:	fffff097          	auipc	ra,0xfffff
    80003550:	0d0080e7          	jalr	208(ra) # 8000261c <brelse>
}
    80003554:	60e2                	ld	ra,24(sp)
    80003556:	6442                	ld	s0,16(sp)
    80003558:	64a2                	ld	s1,8(sp)
    8000355a:	6902                	ld	s2,0(sp)
    8000355c:	6105                	addi	sp,sp,32
    8000355e:	8082                	ret

0000000080003560 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003560:	00022797          	auipc	a5,0x22
    80003564:	cec7a783          	lw	a5,-788(a5) # 8002524c <log+0x2c>
    80003568:	0af05d63          	blez	a5,80003622 <install_trans+0xc2>
{
    8000356c:	7139                	addi	sp,sp,-64
    8000356e:	fc06                	sd	ra,56(sp)
    80003570:	f822                	sd	s0,48(sp)
    80003572:	f426                	sd	s1,40(sp)
    80003574:	f04a                	sd	s2,32(sp)
    80003576:	ec4e                	sd	s3,24(sp)
    80003578:	e852                	sd	s4,16(sp)
    8000357a:	e456                	sd	s5,8(sp)
    8000357c:	e05a                	sd	s6,0(sp)
    8000357e:	0080                	addi	s0,sp,64
    80003580:	8b2a                	mv	s6,a0
    80003582:	00022a97          	auipc	s5,0x22
    80003586:	ccea8a93          	addi	s5,s5,-818 # 80025250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000358a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000358c:	00022997          	auipc	s3,0x22
    80003590:	c9498993          	addi	s3,s3,-876 # 80025220 <log>
    80003594:	a00d                	j	800035b6 <install_trans+0x56>
    brelse(lbuf);
    80003596:	854a                	mv	a0,s2
    80003598:	fffff097          	auipc	ra,0xfffff
    8000359c:	084080e7          	jalr	132(ra) # 8000261c <brelse>
    brelse(dbuf);
    800035a0:	8526                	mv	a0,s1
    800035a2:	fffff097          	auipc	ra,0xfffff
    800035a6:	07a080e7          	jalr	122(ra) # 8000261c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035aa:	2a05                	addiw	s4,s4,1
    800035ac:	0a91                	addi	s5,s5,4
    800035ae:	02c9a783          	lw	a5,44(s3)
    800035b2:	04fa5e63          	bge	s4,a5,8000360e <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035b6:	0189a583          	lw	a1,24(s3)
    800035ba:	014585bb          	addw	a1,a1,s4
    800035be:	2585                	addiw	a1,a1,1
    800035c0:	0289a503          	lw	a0,40(s3)
    800035c4:	fffff097          	auipc	ra,0xfffff
    800035c8:	f28080e7          	jalr	-216(ra) # 800024ec <bread>
    800035cc:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035ce:	000aa583          	lw	a1,0(s5)
    800035d2:	0289a503          	lw	a0,40(s3)
    800035d6:	fffff097          	auipc	ra,0xfffff
    800035da:	f16080e7          	jalr	-234(ra) # 800024ec <bread>
    800035de:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035e0:	40000613          	li	a2,1024
    800035e4:	05890593          	addi	a1,s2,88
    800035e8:	05850513          	addi	a0,a0,88
    800035ec:	ffffd097          	auipc	ra,0xffffd
    800035f0:	bea080e7          	jalr	-1046(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800035f4:	8526                	mv	a0,s1
    800035f6:	fffff097          	auipc	ra,0xfffff
    800035fa:	fe8080e7          	jalr	-24(ra) # 800025de <bwrite>
    if(recovering == 0)
    800035fe:	f80b1ce3          	bnez	s6,80003596 <install_trans+0x36>
      bunpin(dbuf);
    80003602:	8526                	mv	a0,s1
    80003604:	fffff097          	auipc	ra,0xfffff
    80003608:	0f2080e7          	jalr	242(ra) # 800026f6 <bunpin>
    8000360c:	b769                	j	80003596 <install_trans+0x36>
}
    8000360e:	70e2                	ld	ra,56(sp)
    80003610:	7442                	ld	s0,48(sp)
    80003612:	74a2                	ld	s1,40(sp)
    80003614:	7902                	ld	s2,32(sp)
    80003616:	69e2                	ld	s3,24(sp)
    80003618:	6a42                	ld	s4,16(sp)
    8000361a:	6aa2                	ld	s5,8(sp)
    8000361c:	6b02                	ld	s6,0(sp)
    8000361e:	6121                	addi	sp,sp,64
    80003620:	8082                	ret
    80003622:	8082                	ret

0000000080003624 <initlog>:
{
    80003624:	7179                	addi	sp,sp,-48
    80003626:	f406                	sd	ra,40(sp)
    80003628:	f022                	sd	s0,32(sp)
    8000362a:	ec26                	sd	s1,24(sp)
    8000362c:	e84a                	sd	s2,16(sp)
    8000362e:	e44e                	sd	s3,8(sp)
    80003630:	1800                	addi	s0,sp,48
    80003632:	892a                	mv	s2,a0
    80003634:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003636:	00022497          	auipc	s1,0x22
    8000363a:	bea48493          	addi	s1,s1,-1046 # 80025220 <log>
    8000363e:	00005597          	auipc	a1,0x5
    80003642:	f8a58593          	addi	a1,a1,-118 # 800085c8 <syscalls+0x1e8>
    80003646:	8526                	mv	a0,s1
    80003648:	00003097          	auipc	ra,0x3
    8000364c:	f52080e7          	jalr	-174(ra) # 8000659a <initlock>
  log.start = sb->logstart;
    80003650:	0149a583          	lw	a1,20(s3)
    80003654:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003656:	0109a783          	lw	a5,16(s3)
    8000365a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000365c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003660:	854a                	mv	a0,s2
    80003662:	fffff097          	auipc	ra,0xfffff
    80003666:	e8a080e7          	jalr	-374(ra) # 800024ec <bread>
  log.lh.n = lh->n;
    8000366a:	4d34                	lw	a3,88(a0)
    8000366c:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000366e:	02d05663          	blez	a3,8000369a <initlog+0x76>
    80003672:	05c50793          	addi	a5,a0,92
    80003676:	00022717          	auipc	a4,0x22
    8000367a:	bda70713          	addi	a4,a4,-1062 # 80025250 <log+0x30>
    8000367e:	36fd                	addiw	a3,a3,-1
    80003680:	02069613          	slli	a2,a3,0x20
    80003684:	01e65693          	srli	a3,a2,0x1e
    80003688:	06050613          	addi	a2,a0,96
    8000368c:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000368e:	4390                	lw	a2,0(a5)
    80003690:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003692:	0791                	addi	a5,a5,4
    80003694:	0711                	addi	a4,a4,4
    80003696:	fed79ce3          	bne	a5,a3,8000368e <initlog+0x6a>
  brelse(buf);
    8000369a:	fffff097          	auipc	ra,0xfffff
    8000369e:	f82080e7          	jalr	-126(ra) # 8000261c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036a2:	4505                	li	a0,1
    800036a4:	00000097          	auipc	ra,0x0
    800036a8:	ebc080e7          	jalr	-324(ra) # 80003560 <install_trans>
  log.lh.n = 0;
    800036ac:	00022797          	auipc	a5,0x22
    800036b0:	ba07a023          	sw	zero,-1120(a5) # 8002524c <log+0x2c>
  write_head(); // clear the log
    800036b4:	00000097          	auipc	ra,0x0
    800036b8:	e30080e7          	jalr	-464(ra) # 800034e4 <write_head>
}
    800036bc:	70a2                	ld	ra,40(sp)
    800036be:	7402                	ld	s0,32(sp)
    800036c0:	64e2                	ld	s1,24(sp)
    800036c2:	6942                	ld	s2,16(sp)
    800036c4:	69a2                	ld	s3,8(sp)
    800036c6:	6145                	addi	sp,sp,48
    800036c8:	8082                	ret

00000000800036ca <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036ca:	1101                	addi	sp,sp,-32
    800036cc:	ec06                	sd	ra,24(sp)
    800036ce:	e822                	sd	s0,16(sp)
    800036d0:	e426                	sd	s1,8(sp)
    800036d2:	e04a                	sd	s2,0(sp)
    800036d4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036d6:	00022517          	auipc	a0,0x22
    800036da:	b4a50513          	addi	a0,a0,-1206 # 80025220 <log>
    800036de:	00003097          	auipc	ra,0x3
    800036e2:	f4c080e7          	jalr	-180(ra) # 8000662a <acquire>
  while(1){
    if(log.committing){
    800036e6:	00022497          	auipc	s1,0x22
    800036ea:	b3a48493          	addi	s1,s1,-1222 # 80025220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036ee:	4979                	li	s2,30
    800036f0:	a039                	j	800036fe <begin_op+0x34>
      sleep(&log, &log.lock);
    800036f2:	85a6                	mv	a1,s1
    800036f4:	8526                	mv	a0,s1
    800036f6:	ffffe097          	auipc	ra,0xffffe
    800036fa:	ea8080e7          	jalr	-344(ra) # 8000159e <sleep>
    if(log.committing){
    800036fe:	50dc                	lw	a5,36(s1)
    80003700:	fbed                	bnez	a5,800036f2 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003702:	5098                	lw	a4,32(s1)
    80003704:	2705                	addiw	a4,a4,1
    80003706:	0007069b          	sext.w	a3,a4
    8000370a:	0027179b          	slliw	a5,a4,0x2
    8000370e:	9fb9                	addw	a5,a5,a4
    80003710:	0017979b          	slliw	a5,a5,0x1
    80003714:	54d8                	lw	a4,44(s1)
    80003716:	9fb9                	addw	a5,a5,a4
    80003718:	00f95963          	bge	s2,a5,8000372a <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000371c:	85a6                	mv	a1,s1
    8000371e:	8526                	mv	a0,s1
    80003720:	ffffe097          	auipc	ra,0xffffe
    80003724:	e7e080e7          	jalr	-386(ra) # 8000159e <sleep>
    80003728:	bfd9                	j	800036fe <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000372a:	00022517          	auipc	a0,0x22
    8000372e:	af650513          	addi	a0,a0,-1290 # 80025220 <log>
    80003732:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003734:	00003097          	auipc	ra,0x3
    80003738:	faa080e7          	jalr	-86(ra) # 800066de <release>
      break;
    }
  }
}
    8000373c:	60e2                	ld	ra,24(sp)
    8000373e:	6442                	ld	s0,16(sp)
    80003740:	64a2                	ld	s1,8(sp)
    80003742:	6902                	ld	s2,0(sp)
    80003744:	6105                	addi	sp,sp,32
    80003746:	8082                	ret

0000000080003748 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003748:	7139                	addi	sp,sp,-64
    8000374a:	fc06                	sd	ra,56(sp)
    8000374c:	f822                	sd	s0,48(sp)
    8000374e:	f426                	sd	s1,40(sp)
    80003750:	f04a                	sd	s2,32(sp)
    80003752:	ec4e                	sd	s3,24(sp)
    80003754:	e852                	sd	s4,16(sp)
    80003756:	e456                	sd	s5,8(sp)
    80003758:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000375a:	00022497          	auipc	s1,0x22
    8000375e:	ac648493          	addi	s1,s1,-1338 # 80025220 <log>
    80003762:	8526                	mv	a0,s1
    80003764:	00003097          	auipc	ra,0x3
    80003768:	ec6080e7          	jalr	-314(ra) # 8000662a <acquire>
  log.outstanding -= 1;
    8000376c:	509c                	lw	a5,32(s1)
    8000376e:	37fd                	addiw	a5,a5,-1
    80003770:	0007891b          	sext.w	s2,a5
    80003774:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003776:	50dc                	lw	a5,36(s1)
    80003778:	e7b9                	bnez	a5,800037c6 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000377a:	04091e63          	bnez	s2,800037d6 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000377e:	00022497          	auipc	s1,0x22
    80003782:	aa248493          	addi	s1,s1,-1374 # 80025220 <log>
    80003786:	4785                	li	a5,1
    80003788:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000378a:	8526                	mv	a0,s1
    8000378c:	00003097          	auipc	ra,0x3
    80003790:	f52080e7          	jalr	-174(ra) # 800066de <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003794:	54dc                	lw	a5,44(s1)
    80003796:	06f04763          	bgtz	a5,80003804 <end_op+0xbc>
    acquire(&log.lock);
    8000379a:	00022497          	auipc	s1,0x22
    8000379e:	a8648493          	addi	s1,s1,-1402 # 80025220 <log>
    800037a2:	8526                	mv	a0,s1
    800037a4:	00003097          	auipc	ra,0x3
    800037a8:	e86080e7          	jalr	-378(ra) # 8000662a <acquire>
    log.committing = 0;
    800037ac:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037b0:	8526                	mv	a0,s1
    800037b2:	ffffe097          	auipc	ra,0xffffe
    800037b6:	f7e080e7          	jalr	-130(ra) # 80001730 <wakeup>
    release(&log.lock);
    800037ba:	8526                	mv	a0,s1
    800037bc:	00003097          	auipc	ra,0x3
    800037c0:	f22080e7          	jalr	-222(ra) # 800066de <release>
}
    800037c4:	a03d                	j	800037f2 <end_op+0xaa>
    panic("log.committing");
    800037c6:	00005517          	auipc	a0,0x5
    800037ca:	e0a50513          	addi	a0,a0,-502 # 800085d0 <syscalls+0x1f0>
    800037ce:	00003097          	auipc	ra,0x3
    800037d2:	924080e7          	jalr	-1756(ra) # 800060f2 <panic>
    wakeup(&log);
    800037d6:	00022497          	auipc	s1,0x22
    800037da:	a4a48493          	addi	s1,s1,-1462 # 80025220 <log>
    800037de:	8526                	mv	a0,s1
    800037e0:	ffffe097          	auipc	ra,0xffffe
    800037e4:	f50080e7          	jalr	-176(ra) # 80001730 <wakeup>
  release(&log.lock);
    800037e8:	8526                	mv	a0,s1
    800037ea:	00003097          	auipc	ra,0x3
    800037ee:	ef4080e7          	jalr	-268(ra) # 800066de <release>
}
    800037f2:	70e2                	ld	ra,56(sp)
    800037f4:	7442                	ld	s0,48(sp)
    800037f6:	74a2                	ld	s1,40(sp)
    800037f8:	7902                	ld	s2,32(sp)
    800037fa:	69e2                	ld	s3,24(sp)
    800037fc:	6a42                	ld	s4,16(sp)
    800037fe:	6aa2                	ld	s5,8(sp)
    80003800:	6121                	addi	sp,sp,64
    80003802:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003804:	00022a97          	auipc	s5,0x22
    80003808:	a4ca8a93          	addi	s5,s5,-1460 # 80025250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000380c:	00022a17          	auipc	s4,0x22
    80003810:	a14a0a13          	addi	s4,s4,-1516 # 80025220 <log>
    80003814:	018a2583          	lw	a1,24(s4)
    80003818:	012585bb          	addw	a1,a1,s2
    8000381c:	2585                	addiw	a1,a1,1
    8000381e:	028a2503          	lw	a0,40(s4)
    80003822:	fffff097          	auipc	ra,0xfffff
    80003826:	cca080e7          	jalr	-822(ra) # 800024ec <bread>
    8000382a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000382c:	000aa583          	lw	a1,0(s5)
    80003830:	028a2503          	lw	a0,40(s4)
    80003834:	fffff097          	auipc	ra,0xfffff
    80003838:	cb8080e7          	jalr	-840(ra) # 800024ec <bread>
    8000383c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000383e:	40000613          	li	a2,1024
    80003842:	05850593          	addi	a1,a0,88
    80003846:	05848513          	addi	a0,s1,88
    8000384a:	ffffd097          	auipc	ra,0xffffd
    8000384e:	98c080e7          	jalr	-1652(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003852:	8526                	mv	a0,s1
    80003854:	fffff097          	auipc	ra,0xfffff
    80003858:	d8a080e7          	jalr	-630(ra) # 800025de <bwrite>
    brelse(from);
    8000385c:	854e                	mv	a0,s3
    8000385e:	fffff097          	auipc	ra,0xfffff
    80003862:	dbe080e7          	jalr	-578(ra) # 8000261c <brelse>
    brelse(to);
    80003866:	8526                	mv	a0,s1
    80003868:	fffff097          	auipc	ra,0xfffff
    8000386c:	db4080e7          	jalr	-588(ra) # 8000261c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003870:	2905                	addiw	s2,s2,1
    80003872:	0a91                	addi	s5,s5,4
    80003874:	02ca2783          	lw	a5,44(s4)
    80003878:	f8f94ee3          	blt	s2,a5,80003814 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000387c:	00000097          	auipc	ra,0x0
    80003880:	c68080e7          	jalr	-920(ra) # 800034e4 <write_head>
    install_trans(0); // Now install writes to home locations
    80003884:	4501                	li	a0,0
    80003886:	00000097          	auipc	ra,0x0
    8000388a:	cda080e7          	jalr	-806(ra) # 80003560 <install_trans>
    log.lh.n = 0;
    8000388e:	00022797          	auipc	a5,0x22
    80003892:	9a07af23          	sw	zero,-1602(a5) # 8002524c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003896:	00000097          	auipc	ra,0x0
    8000389a:	c4e080e7          	jalr	-946(ra) # 800034e4 <write_head>
    8000389e:	bdf5                	j	8000379a <end_op+0x52>

00000000800038a0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038a0:	1101                	addi	sp,sp,-32
    800038a2:	ec06                	sd	ra,24(sp)
    800038a4:	e822                	sd	s0,16(sp)
    800038a6:	e426                	sd	s1,8(sp)
    800038a8:	e04a                	sd	s2,0(sp)
    800038aa:	1000                	addi	s0,sp,32
    800038ac:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038ae:	00022917          	auipc	s2,0x22
    800038b2:	97290913          	addi	s2,s2,-1678 # 80025220 <log>
    800038b6:	854a                	mv	a0,s2
    800038b8:	00003097          	auipc	ra,0x3
    800038bc:	d72080e7          	jalr	-654(ra) # 8000662a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038c0:	02c92603          	lw	a2,44(s2)
    800038c4:	47f5                	li	a5,29
    800038c6:	06c7c563          	blt	a5,a2,80003930 <log_write+0x90>
    800038ca:	00022797          	auipc	a5,0x22
    800038ce:	9727a783          	lw	a5,-1678(a5) # 8002523c <log+0x1c>
    800038d2:	37fd                	addiw	a5,a5,-1
    800038d4:	04f65e63          	bge	a2,a5,80003930 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038d8:	00022797          	auipc	a5,0x22
    800038dc:	9687a783          	lw	a5,-1688(a5) # 80025240 <log+0x20>
    800038e0:	06f05063          	blez	a5,80003940 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038e4:	4781                	li	a5,0
    800038e6:	06c05563          	blez	a2,80003950 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038ea:	44cc                	lw	a1,12(s1)
    800038ec:	00022717          	auipc	a4,0x22
    800038f0:	96470713          	addi	a4,a4,-1692 # 80025250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800038f4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038f6:	4314                	lw	a3,0(a4)
    800038f8:	04b68c63          	beq	a3,a1,80003950 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800038fc:	2785                	addiw	a5,a5,1
    800038fe:	0711                	addi	a4,a4,4
    80003900:	fef61be3          	bne	a2,a5,800038f6 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003904:	0621                	addi	a2,a2,8
    80003906:	060a                	slli	a2,a2,0x2
    80003908:	00022797          	auipc	a5,0x22
    8000390c:	91878793          	addi	a5,a5,-1768 # 80025220 <log>
    80003910:	97b2                	add	a5,a5,a2
    80003912:	44d8                	lw	a4,12(s1)
    80003914:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003916:	8526                	mv	a0,s1
    80003918:	fffff097          	auipc	ra,0xfffff
    8000391c:	da2080e7          	jalr	-606(ra) # 800026ba <bpin>
    log.lh.n++;
    80003920:	00022717          	auipc	a4,0x22
    80003924:	90070713          	addi	a4,a4,-1792 # 80025220 <log>
    80003928:	575c                	lw	a5,44(a4)
    8000392a:	2785                	addiw	a5,a5,1
    8000392c:	d75c                	sw	a5,44(a4)
    8000392e:	a82d                	j	80003968 <log_write+0xc8>
    panic("too big a transaction");
    80003930:	00005517          	auipc	a0,0x5
    80003934:	cb050513          	addi	a0,a0,-848 # 800085e0 <syscalls+0x200>
    80003938:	00002097          	auipc	ra,0x2
    8000393c:	7ba080e7          	jalr	1978(ra) # 800060f2 <panic>
    panic("log_write outside of trans");
    80003940:	00005517          	auipc	a0,0x5
    80003944:	cb850513          	addi	a0,a0,-840 # 800085f8 <syscalls+0x218>
    80003948:	00002097          	auipc	ra,0x2
    8000394c:	7aa080e7          	jalr	1962(ra) # 800060f2 <panic>
  log.lh.block[i] = b->blockno;
    80003950:	00878693          	addi	a3,a5,8
    80003954:	068a                	slli	a3,a3,0x2
    80003956:	00022717          	auipc	a4,0x22
    8000395a:	8ca70713          	addi	a4,a4,-1846 # 80025220 <log>
    8000395e:	9736                	add	a4,a4,a3
    80003960:	44d4                	lw	a3,12(s1)
    80003962:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003964:	faf609e3          	beq	a2,a5,80003916 <log_write+0x76>
  }
  release(&log.lock);
    80003968:	00022517          	auipc	a0,0x22
    8000396c:	8b850513          	addi	a0,a0,-1864 # 80025220 <log>
    80003970:	00003097          	auipc	ra,0x3
    80003974:	d6e080e7          	jalr	-658(ra) # 800066de <release>
}
    80003978:	60e2                	ld	ra,24(sp)
    8000397a:	6442                	ld	s0,16(sp)
    8000397c:	64a2                	ld	s1,8(sp)
    8000397e:	6902                	ld	s2,0(sp)
    80003980:	6105                	addi	sp,sp,32
    80003982:	8082                	ret

0000000080003984 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003984:	1101                	addi	sp,sp,-32
    80003986:	ec06                	sd	ra,24(sp)
    80003988:	e822                	sd	s0,16(sp)
    8000398a:	e426                	sd	s1,8(sp)
    8000398c:	e04a                	sd	s2,0(sp)
    8000398e:	1000                	addi	s0,sp,32
    80003990:	84aa                	mv	s1,a0
    80003992:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003994:	00005597          	auipc	a1,0x5
    80003998:	c8458593          	addi	a1,a1,-892 # 80008618 <syscalls+0x238>
    8000399c:	0521                	addi	a0,a0,8
    8000399e:	00003097          	auipc	ra,0x3
    800039a2:	bfc080e7          	jalr	-1028(ra) # 8000659a <initlock>
  lk->name = name;
    800039a6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039aa:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039ae:	0204a423          	sw	zero,40(s1)
}
    800039b2:	60e2                	ld	ra,24(sp)
    800039b4:	6442                	ld	s0,16(sp)
    800039b6:	64a2                	ld	s1,8(sp)
    800039b8:	6902                	ld	s2,0(sp)
    800039ba:	6105                	addi	sp,sp,32
    800039bc:	8082                	ret

00000000800039be <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039be:	1101                	addi	sp,sp,-32
    800039c0:	ec06                	sd	ra,24(sp)
    800039c2:	e822                	sd	s0,16(sp)
    800039c4:	e426                	sd	s1,8(sp)
    800039c6:	e04a                	sd	s2,0(sp)
    800039c8:	1000                	addi	s0,sp,32
    800039ca:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039cc:	00850913          	addi	s2,a0,8
    800039d0:	854a                	mv	a0,s2
    800039d2:	00003097          	auipc	ra,0x3
    800039d6:	c58080e7          	jalr	-936(ra) # 8000662a <acquire>
  while (lk->locked) {
    800039da:	409c                	lw	a5,0(s1)
    800039dc:	cb89                	beqz	a5,800039ee <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039de:	85ca                	mv	a1,s2
    800039e0:	8526                	mv	a0,s1
    800039e2:	ffffe097          	auipc	ra,0xffffe
    800039e6:	bbc080e7          	jalr	-1092(ra) # 8000159e <sleep>
  while (lk->locked) {
    800039ea:	409c                	lw	a5,0(s1)
    800039ec:	fbed                	bnez	a5,800039de <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039ee:	4785                	li	a5,1
    800039f0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039f2:	ffffd097          	auipc	ra,0xffffd
    800039f6:	454080e7          	jalr	1108(ra) # 80000e46 <myproc>
    800039fa:	33852783          	lw	a5,824(a0)
    800039fe:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a00:	854a                	mv	a0,s2
    80003a02:	00003097          	auipc	ra,0x3
    80003a06:	cdc080e7          	jalr	-804(ra) # 800066de <release>
}
    80003a0a:	60e2                	ld	ra,24(sp)
    80003a0c:	6442                	ld	s0,16(sp)
    80003a0e:	64a2                	ld	s1,8(sp)
    80003a10:	6902                	ld	s2,0(sp)
    80003a12:	6105                	addi	sp,sp,32
    80003a14:	8082                	ret

0000000080003a16 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a16:	1101                	addi	sp,sp,-32
    80003a18:	ec06                	sd	ra,24(sp)
    80003a1a:	e822                	sd	s0,16(sp)
    80003a1c:	e426                	sd	s1,8(sp)
    80003a1e:	e04a                	sd	s2,0(sp)
    80003a20:	1000                	addi	s0,sp,32
    80003a22:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a24:	00850913          	addi	s2,a0,8
    80003a28:	854a                	mv	a0,s2
    80003a2a:	00003097          	auipc	ra,0x3
    80003a2e:	c00080e7          	jalr	-1024(ra) # 8000662a <acquire>
  lk->locked = 0;
    80003a32:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a36:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a3a:	8526                	mv	a0,s1
    80003a3c:	ffffe097          	auipc	ra,0xffffe
    80003a40:	cf4080e7          	jalr	-780(ra) # 80001730 <wakeup>
  release(&lk->lk);
    80003a44:	854a                	mv	a0,s2
    80003a46:	00003097          	auipc	ra,0x3
    80003a4a:	c98080e7          	jalr	-872(ra) # 800066de <release>
}
    80003a4e:	60e2                	ld	ra,24(sp)
    80003a50:	6442                	ld	s0,16(sp)
    80003a52:	64a2                	ld	s1,8(sp)
    80003a54:	6902                	ld	s2,0(sp)
    80003a56:	6105                	addi	sp,sp,32
    80003a58:	8082                	ret

0000000080003a5a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a5a:	7179                	addi	sp,sp,-48
    80003a5c:	f406                	sd	ra,40(sp)
    80003a5e:	f022                	sd	s0,32(sp)
    80003a60:	ec26                	sd	s1,24(sp)
    80003a62:	e84a                	sd	s2,16(sp)
    80003a64:	e44e                	sd	s3,8(sp)
    80003a66:	1800                	addi	s0,sp,48
    80003a68:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a6a:	00850913          	addi	s2,a0,8
    80003a6e:	854a                	mv	a0,s2
    80003a70:	00003097          	auipc	ra,0x3
    80003a74:	bba080e7          	jalr	-1094(ra) # 8000662a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a78:	409c                	lw	a5,0(s1)
    80003a7a:	ef99                	bnez	a5,80003a98 <holdingsleep+0x3e>
    80003a7c:	4481                	li	s1,0
  release(&lk->lk);
    80003a7e:	854a                	mv	a0,s2
    80003a80:	00003097          	auipc	ra,0x3
    80003a84:	c5e080e7          	jalr	-930(ra) # 800066de <release>
  return r;
}
    80003a88:	8526                	mv	a0,s1
    80003a8a:	70a2                	ld	ra,40(sp)
    80003a8c:	7402                	ld	s0,32(sp)
    80003a8e:	64e2                	ld	s1,24(sp)
    80003a90:	6942                	ld	s2,16(sp)
    80003a92:	69a2                	ld	s3,8(sp)
    80003a94:	6145                	addi	sp,sp,48
    80003a96:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a98:	0284a983          	lw	s3,40(s1)
    80003a9c:	ffffd097          	auipc	ra,0xffffd
    80003aa0:	3aa080e7          	jalr	938(ra) # 80000e46 <myproc>
    80003aa4:	33852483          	lw	s1,824(a0)
    80003aa8:	413484b3          	sub	s1,s1,s3
    80003aac:	0014b493          	seqz	s1,s1
    80003ab0:	b7f9                	j	80003a7e <holdingsleep+0x24>

0000000080003ab2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003ab2:	1141                	addi	sp,sp,-16
    80003ab4:	e406                	sd	ra,8(sp)
    80003ab6:	e022                	sd	s0,0(sp)
    80003ab8:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003aba:	00005597          	auipc	a1,0x5
    80003abe:	b6e58593          	addi	a1,a1,-1170 # 80008628 <syscalls+0x248>
    80003ac2:	00022517          	auipc	a0,0x22
    80003ac6:	8a650513          	addi	a0,a0,-1882 # 80025368 <ftable>
    80003aca:	00003097          	auipc	ra,0x3
    80003ace:	ad0080e7          	jalr	-1328(ra) # 8000659a <initlock>
}
    80003ad2:	60a2                	ld	ra,8(sp)
    80003ad4:	6402                	ld	s0,0(sp)
    80003ad6:	0141                	addi	sp,sp,16
    80003ad8:	8082                	ret

0000000080003ada <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003ada:	1101                	addi	sp,sp,-32
    80003adc:	ec06                	sd	ra,24(sp)
    80003ade:	e822                	sd	s0,16(sp)
    80003ae0:	e426                	sd	s1,8(sp)
    80003ae2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003ae4:	00022517          	auipc	a0,0x22
    80003ae8:	88450513          	addi	a0,a0,-1916 # 80025368 <ftable>
    80003aec:	00003097          	auipc	ra,0x3
    80003af0:	b3e080e7          	jalr	-1218(ra) # 8000662a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003af4:	00022497          	auipc	s1,0x22
    80003af8:	88c48493          	addi	s1,s1,-1908 # 80025380 <ftable+0x18>
    80003afc:	00023717          	auipc	a4,0x23
    80003b00:	82470713          	addi	a4,a4,-2012 # 80026320 <ftable+0xfb8>
    if(f->ref == 0){
    80003b04:	40dc                	lw	a5,4(s1)
    80003b06:	cf99                	beqz	a5,80003b24 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b08:	02848493          	addi	s1,s1,40
    80003b0c:	fee49ce3          	bne	s1,a4,80003b04 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b10:	00022517          	auipc	a0,0x22
    80003b14:	85850513          	addi	a0,a0,-1960 # 80025368 <ftable>
    80003b18:	00003097          	auipc	ra,0x3
    80003b1c:	bc6080e7          	jalr	-1082(ra) # 800066de <release>
  return 0;
    80003b20:	4481                	li	s1,0
    80003b22:	a819                	j	80003b38 <filealloc+0x5e>
      f->ref = 1;
    80003b24:	4785                	li	a5,1
    80003b26:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b28:	00022517          	auipc	a0,0x22
    80003b2c:	84050513          	addi	a0,a0,-1984 # 80025368 <ftable>
    80003b30:	00003097          	auipc	ra,0x3
    80003b34:	bae080e7          	jalr	-1106(ra) # 800066de <release>
}
    80003b38:	8526                	mv	a0,s1
    80003b3a:	60e2                	ld	ra,24(sp)
    80003b3c:	6442                	ld	s0,16(sp)
    80003b3e:	64a2                	ld	s1,8(sp)
    80003b40:	6105                	addi	sp,sp,32
    80003b42:	8082                	ret

0000000080003b44 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b44:	1101                	addi	sp,sp,-32
    80003b46:	ec06                	sd	ra,24(sp)
    80003b48:	e822                	sd	s0,16(sp)
    80003b4a:	e426                	sd	s1,8(sp)
    80003b4c:	1000                	addi	s0,sp,32
    80003b4e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b50:	00022517          	auipc	a0,0x22
    80003b54:	81850513          	addi	a0,a0,-2024 # 80025368 <ftable>
    80003b58:	00003097          	auipc	ra,0x3
    80003b5c:	ad2080e7          	jalr	-1326(ra) # 8000662a <acquire>
  if(f->ref < 1)
    80003b60:	40dc                	lw	a5,4(s1)
    80003b62:	02f05263          	blez	a5,80003b86 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b66:	2785                	addiw	a5,a5,1
    80003b68:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b6a:	00021517          	auipc	a0,0x21
    80003b6e:	7fe50513          	addi	a0,a0,2046 # 80025368 <ftable>
    80003b72:	00003097          	auipc	ra,0x3
    80003b76:	b6c080e7          	jalr	-1172(ra) # 800066de <release>
  return f;
}
    80003b7a:	8526                	mv	a0,s1
    80003b7c:	60e2                	ld	ra,24(sp)
    80003b7e:	6442                	ld	s0,16(sp)
    80003b80:	64a2                	ld	s1,8(sp)
    80003b82:	6105                	addi	sp,sp,32
    80003b84:	8082                	ret
    panic("filedup");
    80003b86:	00005517          	auipc	a0,0x5
    80003b8a:	aaa50513          	addi	a0,a0,-1366 # 80008630 <syscalls+0x250>
    80003b8e:	00002097          	auipc	ra,0x2
    80003b92:	564080e7          	jalr	1380(ra) # 800060f2 <panic>

0000000080003b96 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b96:	7139                	addi	sp,sp,-64
    80003b98:	fc06                	sd	ra,56(sp)
    80003b9a:	f822                	sd	s0,48(sp)
    80003b9c:	f426                	sd	s1,40(sp)
    80003b9e:	f04a                	sd	s2,32(sp)
    80003ba0:	ec4e                	sd	s3,24(sp)
    80003ba2:	e852                	sd	s4,16(sp)
    80003ba4:	e456                	sd	s5,8(sp)
    80003ba6:	0080                	addi	s0,sp,64
    80003ba8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003baa:	00021517          	auipc	a0,0x21
    80003bae:	7be50513          	addi	a0,a0,1982 # 80025368 <ftable>
    80003bb2:	00003097          	auipc	ra,0x3
    80003bb6:	a78080e7          	jalr	-1416(ra) # 8000662a <acquire>
  if(f->ref < 1)
    80003bba:	40dc                	lw	a5,4(s1)
    80003bbc:	06f05163          	blez	a5,80003c1e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003bc0:	37fd                	addiw	a5,a5,-1
    80003bc2:	0007871b          	sext.w	a4,a5
    80003bc6:	c0dc                	sw	a5,4(s1)
    80003bc8:	06e04363          	bgtz	a4,80003c2e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003bcc:	0004a903          	lw	s2,0(s1)
    80003bd0:	0094ca83          	lbu	s5,9(s1)
    80003bd4:	0104ba03          	ld	s4,16(s1)
    80003bd8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003bdc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003be0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003be4:	00021517          	auipc	a0,0x21
    80003be8:	78450513          	addi	a0,a0,1924 # 80025368 <ftable>
    80003bec:	00003097          	auipc	ra,0x3
    80003bf0:	af2080e7          	jalr	-1294(ra) # 800066de <release>

  if(ff.type == FD_PIPE){
    80003bf4:	4785                	li	a5,1
    80003bf6:	04f90d63          	beq	s2,a5,80003c50 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003bfa:	3979                	addiw	s2,s2,-2
    80003bfc:	4785                	li	a5,1
    80003bfe:	0527e063          	bltu	a5,s2,80003c3e <fileclose+0xa8>
    begin_op();
    80003c02:	00000097          	auipc	ra,0x0
    80003c06:	ac8080e7          	jalr	-1336(ra) # 800036ca <begin_op>
    iput(ff.ip);
    80003c0a:	854e                	mv	a0,s3
    80003c0c:	fffff097          	auipc	ra,0xfffff
    80003c10:	29c080e7          	jalr	668(ra) # 80002ea8 <iput>
    end_op();
    80003c14:	00000097          	auipc	ra,0x0
    80003c18:	b34080e7          	jalr	-1228(ra) # 80003748 <end_op>
    80003c1c:	a00d                	j	80003c3e <fileclose+0xa8>
    panic("fileclose");
    80003c1e:	00005517          	auipc	a0,0x5
    80003c22:	a1a50513          	addi	a0,a0,-1510 # 80008638 <syscalls+0x258>
    80003c26:	00002097          	auipc	ra,0x2
    80003c2a:	4cc080e7          	jalr	1228(ra) # 800060f2 <panic>
    release(&ftable.lock);
    80003c2e:	00021517          	auipc	a0,0x21
    80003c32:	73a50513          	addi	a0,a0,1850 # 80025368 <ftable>
    80003c36:	00003097          	auipc	ra,0x3
    80003c3a:	aa8080e7          	jalr	-1368(ra) # 800066de <release>
  }
}
    80003c3e:	70e2                	ld	ra,56(sp)
    80003c40:	7442                	ld	s0,48(sp)
    80003c42:	74a2                	ld	s1,40(sp)
    80003c44:	7902                	ld	s2,32(sp)
    80003c46:	69e2                	ld	s3,24(sp)
    80003c48:	6a42                	ld	s4,16(sp)
    80003c4a:	6aa2                	ld	s5,8(sp)
    80003c4c:	6121                	addi	sp,sp,64
    80003c4e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c50:	85d6                	mv	a1,s5
    80003c52:	8552                	mv	a0,s4
    80003c54:	00000097          	auipc	ra,0x0
    80003c58:	432080e7          	jalr	1074(ra) # 80004086 <pipeclose>
    80003c5c:	b7cd                	j	80003c3e <fileclose+0xa8>

0000000080003c5e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c5e:	715d                	addi	sp,sp,-80
    80003c60:	e486                	sd	ra,72(sp)
    80003c62:	e0a2                	sd	s0,64(sp)
    80003c64:	fc26                	sd	s1,56(sp)
    80003c66:	f84a                	sd	s2,48(sp)
    80003c68:	f44e                	sd	s3,40(sp)
    80003c6a:	0880                	addi	s0,sp,80
    80003c6c:	84aa                	mv	s1,a0
    80003c6e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c70:	ffffd097          	auipc	ra,0xffffd
    80003c74:	1d6080e7          	jalr	470(ra) # 80000e46 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c78:	409c                	lw	a5,0(s1)
    80003c7a:	37f9                	addiw	a5,a5,-2
    80003c7c:	4705                	li	a4,1
    80003c7e:	04f76763          	bltu	a4,a5,80003ccc <filestat+0x6e>
    80003c82:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c84:	6c88                	ld	a0,24(s1)
    80003c86:	fffff097          	auipc	ra,0xfffff
    80003c8a:	068080e7          	jalr	104(ra) # 80002cee <ilock>
    stati(f->ip, &st);
    80003c8e:	fb840593          	addi	a1,s0,-72
    80003c92:	6c88                	ld	a0,24(s1)
    80003c94:	fffff097          	auipc	ra,0xfffff
    80003c98:	2e4080e7          	jalr	740(ra) # 80002f78 <stati>
    iunlock(f->ip);
    80003c9c:	6c88                	ld	a0,24(s1)
    80003c9e:	fffff097          	auipc	ra,0xfffff
    80003ca2:	112080e7          	jalr	274(ra) # 80002db0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ca6:	46e1                	li	a3,24
    80003ca8:	fb840613          	addi	a2,s0,-72
    80003cac:	85ce                	mv	a1,s3
    80003cae:	35893503          	ld	a0,856(s2)
    80003cb2:	ffffd097          	auipc	ra,0xffffd
    80003cb6:	e56080e7          	jalr	-426(ra) # 80000b08 <copyout>
    80003cba:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003cbe:	60a6                	ld	ra,72(sp)
    80003cc0:	6406                	ld	s0,64(sp)
    80003cc2:	74e2                	ld	s1,56(sp)
    80003cc4:	7942                	ld	s2,48(sp)
    80003cc6:	79a2                	ld	s3,40(sp)
    80003cc8:	6161                	addi	sp,sp,80
    80003cca:	8082                	ret
  return -1;
    80003ccc:	557d                	li	a0,-1
    80003cce:	bfc5                	j	80003cbe <filestat+0x60>

0000000080003cd0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003cd0:	7179                	addi	sp,sp,-48
    80003cd2:	f406                	sd	ra,40(sp)
    80003cd4:	f022                	sd	s0,32(sp)
    80003cd6:	ec26                	sd	s1,24(sp)
    80003cd8:	e84a                	sd	s2,16(sp)
    80003cda:	e44e                	sd	s3,8(sp)
    80003cdc:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003cde:	00854783          	lbu	a5,8(a0)
    80003ce2:	c3d5                	beqz	a5,80003d86 <fileread+0xb6>
    80003ce4:	84aa                	mv	s1,a0
    80003ce6:	89ae                	mv	s3,a1
    80003ce8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cea:	411c                	lw	a5,0(a0)
    80003cec:	4705                	li	a4,1
    80003cee:	04e78963          	beq	a5,a4,80003d40 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cf2:	470d                	li	a4,3
    80003cf4:	04e78d63          	beq	a5,a4,80003d4e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cf8:	4709                	li	a4,2
    80003cfa:	06e79e63          	bne	a5,a4,80003d76 <fileread+0xa6>
    ilock(f->ip);
    80003cfe:	6d08                	ld	a0,24(a0)
    80003d00:	fffff097          	auipc	ra,0xfffff
    80003d04:	fee080e7          	jalr	-18(ra) # 80002cee <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d08:	874a                	mv	a4,s2
    80003d0a:	5094                	lw	a3,32(s1)
    80003d0c:	864e                	mv	a2,s3
    80003d0e:	4585                	li	a1,1
    80003d10:	6c88                	ld	a0,24(s1)
    80003d12:	fffff097          	auipc	ra,0xfffff
    80003d16:	290080e7          	jalr	656(ra) # 80002fa2 <readi>
    80003d1a:	892a                	mv	s2,a0
    80003d1c:	00a05563          	blez	a0,80003d26 <fileread+0x56>
      f->off += r;
    80003d20:	509c                	lw	a5,32(s1)
    80003d22:	9fa9                	addw	a5,a5,a0
    80003d24:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d26:	6c88                	ld	a0,24(s1)
    80003d28:	fffff097          	auipc	ra,0xfffff
    80003d2c:	088080e7          	jalr	136(ra) # 80002db0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d30:	854a                	mv	a0,s2
    80003d32:	70a2                	ld	ra,40(sp)
    80003d34:	7402                	ld	s0,32(sp)
    80003d36:	64e2                	ld	s1,24(sp)
    80003d38:	6942                	ld	s2,16(sp)
    80003d3a:	69a2                	ld	s3,8(sp)
    80003d3c:	6145                	addi	sp,sp,48
    80003d3e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d40:	6908                	ld	a0,16(a0)
    80003d42:	00000097          	auipc	ra,0x0
    80003d46:	4a6080e7          	jalr	1190(ra) # 800041e8 <piperead>
    80003d4a:	892a                	mv	s2,a0
    80003d4c:	b7d5                	j	80003d30 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d4e:	02451783          	lh	a5,36(a0)
    80003d52:	03079693          	slli	a3,a5,0x30
    80003d56:	92c1                	srli	a3,a3,0x30
    80003d58:	4725                	li	a4,9
    80003d5a:	02d76863          	bltu	a4,a3,80003d8a <fileread+0xba>
    80003d5e:	0792                	slli	a5,a5,0x4
    80003d60:	00021717          	auipc	a4,0x21
    80003d64:	56870713          	addi	a4,a4,1384 # 800252c8 <devsw>
    80003d68:	97ba                	add	a5,a5,a4
    80003d6a:	639c                	ld	a5,0(a5)
    80003d6c:	c38d                	beqz	a5,80003d8e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d6e:	4505                	li	a0,1
    80003d70:	9782                	jalr	a5
    80003d72:	892a                	mv	s2,a0
    80003d74:	bf75                	j	80003d30 <fileread+0x60>
    panic("fileread");
    80003d76:	00005517          	auipc	a0,0x5
    80003d7a:	8d250513          	addi	a0,a0,-1838 # 80008648 <syscalls+0x268>
    80003d7e:	00002097          	auipc	ra,0x2
    80003d82:	374080e7          	jalr	884(ra) # 800060f2 <panic>
    return -1;
    80003d86:	597d                	li	s2,-1
    80003d88:	b765                	j	80003d30 <fileread+0x60>
      return -1;
    80003d8a:	597d                	li	s2,-1
    80003d8c:	b755                	j	80003d30 <fileread+0x60>
    80003d8e:	597d                	li	s2,-1
    80003d90:	b745                	j	80003d30 <fileread+0x60>

0000000080003d92 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d92:	715d                	addi	sp,sp,-80
    80003d94:	e486                	sd	ra,72(sp)
    80003d96:	e0a2                	sd	s0,64(sp)
    80003d98:	fc26                	sd	s1,56(sp)
    80003d9a:	f84a                	sd	s2,48(sp)
    80003d9c:	f44e                	sd	s3,40(sp)
    80003d9e:	f052                	sd	s4,32(sp)
    80003da0:	ec56                	sd	s5,24(sp)
    80003da2:	e85a                	sd	s6,16(sp)
    80003da4:	e45e                	sd	s7,8(sp)
    80003da6:	e062                	sd	s8,0(sp)
    80003da8:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003daa:	00954783          	lbu	a5,9(a0)
    80003dae:	10078663          	beqz	a5,80003eba <filewrite+0x128>
    80003db2:	892a                	mv	s2,a0
    80003db4:	8b2e                	mv	s6,a1
    80003db6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003db8:	411c                	lw	a5,0(a0)
    80003dba:	4705                	li	a4,1
    80003dbc:	02e78263          	beq	a5,a4,80003de0 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dc0:	470d                	li	a4,3
    80003dc2:	02e78663          	beq	a5,a4,80003dee <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003dc6:	4709                	li	a4,2
    80003dc8:	0ee79163          	bne	a5,a4,80003eaa <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003dcc:	0ac05d63          	blez	a2,80003e86 <filewrite+0xf4>
    int i = 0;
    80003dd0:	4981                	li	s3,0
    80003dd2:	6b85                	lui	s7,0x1
    80003dd4:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003dd8:	6c05                	lui	s8,0x1
    80003dda:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003dde:	a861                	j	80003e76 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003de0:	6908                	ld	a0,16(a0)
    80003de2:	00000097          	auipc	ra,0x0
    80003de6:	314080e7          	jalr	788(ra) # 800040f6 <pipewrite>
    80003dea:	8a2a                	mv	s4,a0
    80003dec:	a045                	j	80003e8c <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003dee:	02451783          	lh	a5,36(a0)
    80003df2:	03079693          	slli	a3,a5,0x30
    80003df6:	92c1                	srli	a3,a3,0x30
    80003df8:	4725                	li	a4,9
    80003dfa:	0cd76263          	bltu	a4,a3,80003ebe <filewrite+0x12c>
    80003dfe:	0792                	slli	a5,a5,0x4
    80003e00:	00021717          	auipc	a4,0x21
    80003e04:	4c870713          	addi	a4,a4,1224 # 800252c8 <devsw>
    80003e08:	97ba                	add	a5,a5,a4
    80003e0a:	679c                	ld	a5,8(a5)
    80003e0c:	cbdd                	beqz	a5,80003ec2 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e0e:	4505                	li	a0,1
    80003e10:	9782                	jalr	a5
    80003e12:	8a2a                	mv	s4,a0
    80003e14:	a8a5                	j	80003e8c <filewrite+0xfa>
    80003e16:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e1a:	00000097          	auipc	ra,0x0
    80003e1e:	8b0080e7          	jalr	-1872(ra) # 800036ca <begin_op>
      ilock(f->ip);
    80003e22:	01893503          	ld	a0,24(s2)
    80003e26:	fffff097          	auipc	ra,0xfffff
    80003e2a:	ec8080e7          	jalr	-312(ra) # 80002cee <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e2e:	8756                	mv	a4,s5
    80003e30:	02092683          	lw	a3,32(s2)
    80003e34:	01698633          	add	a2,s3,s6
    80003e38:	4585                	li	a1,1
    80003e3a:	01893503          	ld	a0,24(s2)
    80003e3e:	fffff097          	auipc	ra,0xfffff
    80003e42:	25c080e7          	jalr	604(ra) # 8000309a <writei>
    80003e46:	84aa                	mv	s1,a0
    80003e48:	00a05763          	blez	a0,80003e56 <filewrite+0xc4>
        f->off += r;
    80003e4c:	02092783          	lw	a5,32(s2)
    80003e50:	9fa9                	addw	a5,a5,a0
    80003e52:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e56:	01893503          	ld	a0,24(s2)
    80003e5a:	fffff097          	auipc	ra,0xfffff
    80003e5e:	f56080e7          	jalr	-170(ra) # 80002db0 <iunlock>
      end_op();
    80003e62:	00000097          	auipc	ra,0x0
    80003e66:	8e6080e7          	jalr	-1818(ra) # 80003748 <end_op>

      if(r != n1){
    80003e6a:	009a9f63          	bne	s5,s1,80003e88 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e6e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e72:	0149db63          	bge	s3,s4,80003e88 <filewrite+0xf6>
      int n1 = n - i;
    80003e76:	413a04bb          	subw	s1,s4,s3
    80003e7a:	0004879b          	sext.w	a5,s1
    80003e7e:	f8fbdce3          	bge	s7,a5,80003e16 <filewrite+0x84>
    80003e82:	84e2                	mv	s1,s8
    80003e84:	bf49                	j	80003e16 <filewrite+0x84>
    int i = 0;
    80003e86:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e88:	013a1f63          	bne	s4,s3,80003ea6 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e8c:	8552                	mv	a0,s4
    80003e8e:	60a6                	ld	ra,72(sp)
    80003e90:	6406                	ld	s0,64(sp)
    80003e92:	74e2                	ld	s1,56(sp)
    80003e94:	7942                	ld	s2,48(sp)
    80003e96:	79a2                	ld	s3,40(sp)
    80003e98:	7a02                	ld	s4,32(sp)
    80003e9a:	6ae2                	ld	s5,24(sp)
    80003e9c:	6b42                	ld	s6,16(sp)
    80003e9e:	6ba2                	ld	s7,8(sp)
    80003ea0:	6c02                	ld	s8,0(sp)
    80003ea2:	6161                	addi	sp,sp,80
    80003ea4:	8082                	ret
    ret = (i == n ? n : -1);
    80003ea6:	5a7d                	li	s4,-1
    80003ea8:	b7d5                	j	80003e8c <filewrite+0xfa>
    panic("filewrite");
    80003eaa:	00004517          	auipc	a0,0x4
    80003eae:	7ae50513          	addi	a0,a0,1966 # 80008658 <syscalls+0x278>
    80003eb2:	00002097          	auipc	ra,0x2
    80003eb6:	240080e7          	jalr	576(ra) # 800060f2 <panic>
    return -1;
    80003eba:	5a7d                	li	s4,-1
    80003ebc:	bfc1                	j	80003e8c <filewrite+0xfa>
      return -1;
    80003ebe:	5a7d                	li	s4,-1
    80003ec0:	b7f1                	j	80003e8c <filewrite+0xfa>
    80003ec2:	5a7d                	li	s4,-1
    80003ec4:	b7e1                	j	80003e8c <filewrite+0xfa>

0000000080003ec6 <filewriteoff>:

int filewriteoff(struct file *f, uint64 addr, int n , int off)
 {
    80003ec6:	711d                	addi	sp,sp,-96
    80003ec8:	ec86                	sd	ra,88(sp)
    80003eca:	e8a2                	sd	s0,80(sp)
    80003ecc:	e4a6                	sd	s1,72(sp)
    80003ece:	e0ca                	sd	s2,64(sp)
    80003ed0:	fc4e                	sd	s3,56(sp)
    80003ed2:	f852                	sd	s4,48(sp)
    80003ed4:	f456                	sd	s5,40(sp)
    80003ed6:	f05a                	sd	s6,32(sp)
    80003ed8:	ec5e                	sd	s7,24(sp)
    80003eda:	e862                	sd	s8,16(sp)
    80003edc:	e466                	sd	s9,8(sp)
    80003ede:	1080                	addi	s0,sp,96
   int r, ret = 0;
 
   if(f->writable == 0)
    80003ee0:	00954783          	lbu	a5,9(a0)
    80003ee4:	c3f1                	beqz	a5,80003fa8 <filewriteoff+0xe2>
    80003ee6:	89aa                	mv	s3,a0
    80003ee8:	8bae                	mv	s7,a1
    80003eea:	8a32                	mv	s4,a2
    80003eec:	8ab6                	mv	s5,a3
     return -1;
 
   if(f->type == FD_INODE){
    80003eee:	4118                	lw	a4,0(a0)
    80003ef0:	4789                	li	a5,2
    80003ef2:	0af71363          	bne	a4,a5,80003f98 <filewriteoff+0xd2>
   int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
   int i = 0;
   while(i < n){
    80003ef6:	06c05e63          	blez	a2,80003f72 <filewriteoff+0xac>
   int i = 0;
    80003efa:	4901                	li	s2,0
    80003efc:	6c05                	lui	s8,0x1
    80003efe:	c00c0c13          	addi	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003f02:	6c85                	lui	s9,0x1
    80003f04:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
    80003f08:	a8a9                	j	80003f62 <filewriteoff+0x9c>
    80003f0a:	00048b1b          	sext.w	s6,s1
     int n1 = n - i;
     if(n1 > max)
       n1 = max;
 
     begin_op();
    80003f0e:	fffff097          	auipc	ra,0xfffff
    80003f12:	7bc080e7          	jalr	1980(ra) # 800036ca <begin_op>
     ilock(f->ip);
    80003f16:	0189b503          	ld	a0,24(s3)
    80003f1a:	fffff097          	auipc	ra,0xfffff
    80003f1e:	dd4080e7          	jalr	-556(ra) # 80002cee <ilock>
     if ((r = writei(f->ip, 1, addr + i, off, n1)) > 0)
    80003f22:	875a                	mv	a4,s6
    80003f24:	86d6                	mv	a3,s5
    80003f26:	01790633          	add	a2,s2,s7
    80003f2a:	4585                	li	a1,1
    80003f2c:	0189b503          	ld	a0,24(s3)
    80003f30:	fffff097          	auipc	ra,0xfffff
    80003f34:	16a080e7          	jalr	362(ra) # 8000309a <writei>
    80003f38:	84aa                	mv	s1,a0
    80003f3a:	00a05463          	blez	a0,80003f42 <filewriteoff+0x7c>
       off += r;
    80003f3e:	01550abb          	addw	s5,a0,s5
     iunlock(f->ip);
    80003f42:	0189b503          	ld	a0,24(s3)
    80003f46:	fffff097          	auipc	ra,0xfffff
    80003f4a:	e6a080e7          	jalr	-406(ra) # 80002db0 <iunlock>
     end_op();
    80003f4e:	fffff097          	auipc	ra,0xfffff
    80003f52:	7fa080e7          	jalr	2042(ra) # 80003748 <end_op>
 
     if(r != n1){
    80003f56:	009b1f63          	bne	s6,s1,80003f74 <filewriteoff+0xae>
       // error from writei
       break;
     }
     i += r;
    80003f5a:	0124893b          	addw	s2,s1,s2
   while(i < n){
    80003f5e:	01495b63          	bge	s2,s4,80003f74 <filewriteoff+0xae>
     int n1 = n - i;
    80003f62:	412a04bb          	subw	s1,s4,s2
    80003f66:	0004879b          	sext.w	a5,s1
    80003f6a:	fafc50e3          	bge	s8,a5,80003f0a <filewriteoff+0x44>
    80003f6e:	84e6                	mv	s1,s9
    80003f70:	bf69                	j	80003f0a <filewriteoff+0x44>
   int i = 0;
    80003f72:	4901                	li	s2,0
   }
   ret = (i == n ? n : -1);
    80003f74:	032a1063          	bne	s4,s2,80003f94 <filewriteoff+0xce>
 } else {
   panic("my filewrite");
 }
   return ret;
    80003f78:	8552                	mv	a0,s4
    80003f7a:	60e6                	ld	ra,88(sp)
    80003f7c:	6446                	ld	s0,80(sp)
    80003f7e:	64a6                	ld	s1,72(sp)
    80003f80:	6906                	ld	s2,64(sp)
    80003f82:	79e2                	ld	s3,56(sp)
    80003f84:	7a42                	ld	s4,48(sp)
    80003f86:	7aa2                	ld	s5,40(sp)
    80003f88:	7b02                	ld	s6,32(sp)
    80003f8a:	6be2                	ld	s7,24(sp)
    80003f8c:	6c42                	ld	s8,16(sp)
    80003f8e:	6ca2                	ld	s9,8(sp)
    80003f90:	6125                	addi	sp,sp,96
    80003f92:	8082                	ret
   ret = (i == n ? n : -1);
    80003f94:	5a7d                	li	s4,-1
    80003f96:	b7cd                	j	80003f78 <filewriteoff+0xb2>
   panic("my filewrite");
    80003f98:	00004517          	auipc	a0,0x4
    80003f9c:	6d050513          	addi	a0,a0,1744 # 80008668 <syscalls+0x288>
    80003fa0:	00002097          	auipc	ra,0x2
    80003fa4:	152080e7          	jalr	338(ra) # 800060f2 <panic>
     return -1;
    80003fa8:	5a7d                	li	s4,-1
    80003faa:	b7f9                	j	80003f78 <filewriteoff+0xb2>

0000000080003fac <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003fac:	7179                	addi	sp,sp,-48
    80003fae:	f406                	sd	ra,40(sp)
    80003fb0:	f022                	sd	s0,32(sp)
    80003fb2:	ec26                	sd	s1,24(sp)
    80003fb4:	e84a                	sd	s2,16(sp)
    80003fb6:	e44e                	sd	s3,8(sp)
    80003fb8:	e052                	sd	s4,0(sp)
    80003fba:	1800                	addi	s0,sp,48
    80003fbc:	84aa                	mv	s1,a0
    80003fbe:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003fc0:	0005b023          	sd	zero,0(a1)
    80003fc4:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003fc8:	00000097          	auipc	ra,0x0
    80003fcc:	b12080e7          	jalr	-1262(ra) # 80003ada <filealloc>
    80003fd0:	e088                	sd	a0,0(s1)
    80003fd2:	c551                	beqz	a0,8000405e <pipealloc+0xb2>
    80003fd4:	00000097          	auipc	ra,0x0
    80003fd8:	b06080e7          	jalr	-1274(ra) # 80003ada <filealloc>
    80003fdc:	00aa3023          	sd	a0,0(s4)
    80003fe0:	c92d                	beqz	a0,80004052 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003fe2:	ffffc097          	auipc	ra,0xffffc
    80003fe6:	138080e7          	jalr	312(ra) # 8000011a <kalloc>
    80003fea:	892a                	mv	s2,a0
    80003fec:	c125                	beqz	a0,8000404c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003fee:	4985                	li	s3,1
    80003ff0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ff4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ff8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003ffc:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004000:	00004597          	auipc	a1,0x4
    80004004:	67858593          	addi	a1,a1,1656 # 80008678 <syscalls+0x298>
    80004008:	00002097          	auipc	ra,0x2
    8000400c:	592080e7          	jalr	1426(ra) # 8000659a <initlock>
  (*f0)->type = FD_PIPE;
    80004010:	609c                	ld	a5,0(s1)
    80004012:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004016:	609c                	ld	a5,0(s1)
    80004018:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000401c:	609c                	ld	a5,0(s1)
    8000401e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004022:	609c                	ld	a5,0(s1)
    80004024:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004028:	000a3783          	ld	a5,0(s4)
    8000402c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004030:	000a3783          	ld	a5,0(s4)
    80004034:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004038:	000a3783          	ld	a5,0(s4)
    8000403c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004040:	000a3783          	ld	a5,0(s4)
    80004044:	0127b823          	sd	s2,16(a5)
  return 0;
    80004048:	4501                	li	a0,0
    8000404a:	a025                	j	80004072 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000404c:	6088                	ld	a0,0(s1)
    8000404e:	e501                	bnez	a0,80004056 <pipealloc+0xaa>
    80004050:	a039                	j	8000405e <pipealloc+0xb2>
    80004052:	6088                	ld	a0,0(s1)
    80004054:	c51d                	beqz	a0,80004082 <pipealloc+0xd6>
    fileclose(*f0);
    80004056:	00000097          	auipc	ra,0x0
    8000405a:	b40080e7          	jalr	-1216(ra) # 80003b96 <fileclose>
  if(*f1)
    8000405e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004062:	557d                	li	a0,-1
  if(*f1)
    80004064:	c799                	beqz	a5,80004072 <pipealloc+0xc6>
    fileclose(*f1);
    80004066:	853e                	mv	a0,a5
    80004068:	00000097          	auipc	ra,0x0
    8000406c:	b2e080e7          	jalr	-1234(ra) # 80003b96 <fileclose>
  return -1;
    80004070:	557d                	li	a0,-1
}
    80004072:	70a2                	ld	ra,40(sp)
    80004074:	7402                	ld	s0,32(sp)
    80004076:	64e2                	ld	s1,24(sp)
    80004078:	6942                	ld	s2,16(sp)
    8000407a:	69a2                	ld	s3,8(sp)
    8000407c:	6a02                	ld	s4,0(sp)
    8000407e:	6145                	addi	sp,sp,48
    80004080:	8082                	ret
  return -1;
    80004082:	557d                	li	a0,-1
    80004084:	b7fd                	j	80004072 <pipealloc+0xc6>

0000000080004086 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004086:	1101                	addi	sp,sp,-32
    80004088:	ec06                	sd	ra,24(sp)
    8000408a:	e822                	sd	s0,16(sp)
    8000408c:	e426                	sd	s1,8(sp)
    8000408e:	e04a                	sd	s2,0(sp)
    80004090:	1000                	addi	s0,sp,32
    80004092:	84aa                	mv	s1,a0
    80004094:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004096:	00002097          	auipc	ra,0x2
    8000409a:	594080e7          	jalr	1428(ra) # 8000662a <acquire>
  if(writable){
    8000409e:	02090d63          	beqz	s2,800040d8 <pipeclose+0x52>
    pi->writeopen = 0;
    800040a2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800040a6:	21848513          	addi	a0,s1,536
    800040aa:	ffffd097          	auipc	ra,0xffffd
    800040ae:	686080e7          	jalr	1670(ra) # 80001730 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800040b2:	2204b783          	ld	a5,544(s1)
    800040b6:	eb95                	bnez	a5,800040ea <pipeclose+0x64>
    release(&pi->lock);
    800040b8:	8526                	mv	a0,s1
    800040ba:	00002097          	auipc	ra,0x2
    800040be:	624080e7          	jalr	1572(ra) # 800066de <release>
    kfree((char*)pi);
    800040c2:	8526                	mv	a0,s1
    800040c4:	ffffc097          	auipc	ra,0xffffc
    800040c8:	f58080e7          	jalr	-168(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    800040cc:	60e2                	ld	ra,24(sp)
    800040ce:	6442                	ld	s0,16(sp)
    800040d0:	64a2                	ld	s1,8(sp)
    800040d2:	6902                	ld	s2,0(sp)
    800040d4:	6105                	addi	sp,sp,32
    800040d6:	8082                	ret
    pi->readopen = 0;
    800040d8:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800040dc:	21c48513          	addi	a0,s1,540
    800040e0:	ffffd097          	auipc	ra,0xffffd
    800040e4:	650080e7          	jalr	1616(ra) # 80001730 <wakeup>
    800040e8:	b7e9                	j	800040b2 <pipeclose+0x2c>
    release(&pi->lock);
    800040ea:	8526                	mv	a0,s1
    800040ec:	00002097          	auipc	ra,0x2
    800040f0:	5f2080e7          	jalr	1522(ra) # 800066de <release>
}
    800040f4:	bfe1                	j	800040cc <pipeclose+0x46>

00000000800040f6 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800040f6:	711d                	addi	sp,sp,-96
    800040f8:	ec86                	sd	ra,88(sp)
    800040fa:	e8a2                	sd	s0,80(sp)
    800040fc:	e4a6                	sd	s1,72(sp)
    800040fe:	e0ca                	sd	s2,64(sp)
    80004100:	fc4e                	sd	s3,56(sp)
    80004102:	f852                	sd	s4,48(sp)
    80004104:	f456                	sd	s5,40(sp)
    80004106:	f05a                	sd	s6,32(sp)
    80004108:	ec5e                	sd	s7,24(sp)
    8000410a:	e862                	sd	s8,16(sp)
    8000410c:	1080                	addi	s0,sp,96
    8000410e:	84aa                	mv	s1,a0
    80004110:	8aae                	mv	s5,a1
    80004112:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004114:	ffffd097          	auipc	ra,0xffffd
    80004118:	d32080e7          	jalr	-718(ra) # 80000e46 <myproc>
    8000411c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000411e:	8526                	mv	a0,s1
    80004120:	00002097          	auipc	ra,0x2
    80004124:	50a080e7          	jalr	1290(ra) # 8000662a <acquire>
  while(i < n){
    80004128:	0b405363          	blez	s4,800041ce <pipewrite+0xd8>
  int i = 0;
    8000412c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000412e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004130:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004134:	21c48b93          	addi	s7,s1,540
    80004138:	a089                	j	8000417a <pipewrite+0x84>
      release(&pi->lock);
    8000413a:	8526                	mv	a0,s1
    8000413c:	00002097          	auipc	ra,0x2
    80004140:	5a2080e7          	jalr	1442(ra) # 800066de <release>
      return -1;
    80004144:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004146:	854a                	mv	a0,s2
    80004148:	60e6                	ld	ra,88(sp)
    8000414a:	6446                	ld	s0,80(sp)
    8000414c:	64a6                	ld	s1,72(sp)
    8000414e:	6906                	ld	s2,64(sp)
    80004150:	79e2                	ld	s3,56(sp)
    80004152:	7a42                	ld	s4,48(sp)
    80004154:	7aa2                	ld	s5,40(sp)
    80004156:	7b02                	ld	s6,32(sp)
    80004158:	6be2                	ld	s7,24(sp)
    8000415a:	6c42                	ld	s8,16(sp)
    8000415c:	6125                	addi	sp,sp,96
    8000415e:	8082                	ret
      wakeup(&pi->nread);
    80004160:	8562                	mv	a0,s8
    80004162:	ffffd097          	auipc	ra,0xffffd
    80004166:	5ce080e7          	jalr	1486(ra) # 80001730 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000416a:	85a6                	mv	a1,s1
    8000416c:	855e                	mv	a0,s7
    8000416e:	ffffd097          	auipc	ra,0xffffd
    80004172:	430080e7          	jalr	1072(ra) # 8000159e <sleep>
  while(i < n){
    80004176:	05495d63          	bge	s2,s4,800041d0 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    8000417a:	2204a783          	lw	a5,544(s1)
    8000417e:	dfd5                	beqz	a5,8000413a <pipewrite+0x44>
    80004180:	3309a783          	lw	a5,816(s3)
    80004184:	fbdd                	bnez	a5,8000413a <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004186:	2184a783          	lw	a5,536(s1)
    8000418a:	21c4a703          	lw	a4,540(s1)
    8000418e:	2007879b          	addiw	a5,a5,512
    80004192:	fcf707e3          	beq	a4,a5,80004160 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004196:	4685                	li	a3,1
    80004198:	01590633          	add	a2,s2,s5
    8000419c:	faf40593          	addi	a1,s0,-81
    800041a0:	3589b503          	ld	a0,856(s3)
    800041a4:	ffffd097          	auipc	ra,0xffffd
    800041a8:	9f0080e7          	jalr	-1552(ra) # 80000b94 <copyin>
    800041ac:	03650263          	beq	a0,s6,800041d0 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800041b0:	21c4a783          	lw	a5,540(s1)
    800041b4:	0017871b          	addiw	a4,a5,1
    800041b8:	20e4ae23          	sw	a4,540(s1)
    800041bc:	1ff7f793          	andi	a5,a5,511
    800041c0:	97a6                	add	a5,a5,s1
    800041c2:	faf44703          	lbu	a4,-81(s0)
    800041c6:	00e78c23          	sb	a4,24(a5)
      i++;
    800041ca:	2905                	addiw	s2,s2,1
    800041cc:	b76d                	j	80004176 <pipewrite+0x80>
  int i = 0;
    800041ce:	4901                	li	s2,0
  wakeup(&pi->nread);
    800041d0:	21848513          	addi	a0,s1,536
    800041d4:	ffffd097          	auipc	ra,0xffffd
    800041d8:	55c080e7          	jalr	1372(ra) # 80001730 <wakeup>
  release(&pi->lock);
    800041dc:	8526                	mv	a0,s1
    800041de:	00002097          	auipc	ra,0x2
    800041e2:	500080e7          	jalr	1280(ra) # 800066de <release>
  return i;
    800041e6:	b785                	j	80004146 <pipewrite+0x50>

00000000800041e8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800041e8:	715d                	addi	sp,sp,-80
    800041ea:	e486                	sd	ra,72(sp)
    800041ec:	e0a2                	sd	s0,64(sp)
    800041ee:	fc26                	sd	s1,56(sp)
    800041f0:	f84a                	sd	s2,48(sp)
    800041f2:	f44e                	sd	s3,40(sp)
    800041f4:	f052                	sd	s4,32(sp)
    800041f6:	ec56                	sd	s5,24(sp)
    800041f8:	e85a                	sd	s6,16(sp)
    800041fa:	0880                	addi	s0,sp,80
    800041fc:	84aa                	mv	s1,a0
    800041fe:	892e                	mv	s2,a1
    80004200:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004202:	ffffd097          	auipc	ra,0xffffd
    80004206:	c44080e7          	jalr	-956(ra) # 80000e46 <myproc>
    8000420a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000420c:	8526                	mv	a0,s1
    8000420e:	00002097          	auipc	ra,0x2
    80004212:	41c080e7          	jalr	1052(ra) # 8000662a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004216:	2184a703          	lw	a4,536(s1)
    8000421a:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000421e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004222:	02f71463          	bne	a4,a5,8000424a <piperead+0x62>
    80004226:	2244a783          	lw	a5,548(s1)
    8000422a:	c385                	beqz	a5,8000424a <piperead+0x62>
    if(pr->killed){
    8000422c:	330a2783          	lw	a5,816(s4)
    80004230:	ebc9                	bnez	a5,800042c2 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004232:	85a6                	mv	a1,s1
    80004234:	854e                	mv	a0,s3
    80004236:	ffffd097          	auipc	ra,0xffffd
    8000423a:	368080e7          	jalr	872(ra) # 8000159e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000423e:	2184a703          	lw	a4,536(s1)
    80004242:	21c4a783          	lw	a5,540(s1)
    80004246:	fef700e3          	beq	a4,a5,80004226 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000424a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000424c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000424e:	05505463          	blez	s5,80004296 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004252:	2184a783          	lw	a5,536(s1)
    80004256:	21c4a703          	lw	a4,540(s1)
    8000425a:	02f70e63          	beq	a4,a5,80004296 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000425e:	0017871b          	addiw	a4,a5,1
    80004262:	20e4ac23          	sw	a4,536(s1)
    80004266:	1ff7f793          	andi	a5,a5,511
    8000426a:	97a6                	add	a5,a5,s1
    8000426c:	0187c783          	lbu	a5,24(a5)
    80004270:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004274:	4685                	li	a3,1
    80004276:	fbf40613          	addi	a2,s0,-65
    8000427a:	85ca                	mv	a1,s2
    8000427c:	358a3503          	ld	a0,856(s4)
    80004280:	ffffd097          	auipc	ra,0xffffd
    80004284:	888080e7          	jalr	-1912(ra) # 80000b08 <copyout>
    80004288:	01650763          	beq	a0,s6,80004296 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000428c:	2985                	addiw	s3,s3,1
    8000428e:	0905                	addi	s2,s2,1
    80004290:	fd3a91e3          	bne	s5,s3,80004252 <piperead+0x6a>
    80004294:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004296:	21c48513          	addi	a0,s1,540
    8000429a:	ffffd097          	auipc	ra,0xffffd
    8000429e:	496080e7          	jalr	1174(ra) # 80001730 <wakeup>
  release(&pi->lock);
    800042a2:	8526                	mv	a0,s1
    800042a4:	00002097          	auipc	ra,0x2
    800042a8:	43a080e7          	jalr	1082(ra) # 800066de <release>
  return i;
}
    800042ac:	854e                	mv	a0,s3
    800042ae:	60a6                	ld	ra,72(sp)
    800042b0:	6406                	ld	s0,64(sp)
    800042b2:	74e2                	ld	s1,56(sp)
    800042b4:	7942                	ld	s2,48(sp)
    800042b6:	79a2                	ld	s3,40(sp)
    800042b8:	7a02                	ld	s4,32(sp)
    800042ba:	6ae2                	ld	s5,24(sp)
    800042bc:	6b42                	ld	s6,16(sp)
    800042be:	6161                	addi	sp,sp,80
    800042c0:	8082                	ret
      release(&pi->lock);
    800042c2:	8526                	mv	a0,s1
    800042c4:	00002097          	auipc	ra,0x2
    800042c8:	41a080e7          	jalr	1050(ra) # 800066de <release>
      return -1;
    800042cc:	59fd                	li	s3,-1
    800042ce:	bff9                	j	800042ac <piperead+0xc4>

00000000800042d0 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800042d0:	de010113          	addi	sp,sp,-544
    800042d4:	20113c23          	sd	ra,536(sp)
    800042d8:	20813823          	sd	s0,528(sp)
    800042dc:	20913423          	sd	s1,520(sp)
    800042e0:	21213023          	sd	s2,512(sp)
    800042e4:	ffce                	sd	s3,504(sp)
    800042e6:	fbd2                	sd	s4,496(sp)
    800042e8:	f7d6                	sd	s5,488(sp)
    800042ea:	f3da                	sd	s6,480(sp)
    800042ec:	efde                	sd	s7,472(sp)
    800042ee:	ebe2                	sd	s8,464(sp)
    800042f0:	e7e6                	sd	s9,456(sp)
    800042f2:	e3ea                	sd	s10,448(sp)
    800042f4:	ff6e                	sd	s11,440(sp)
    800042f6:	1400                	addi	s0,sp,544
    800042f8:	892a                	mv	s2,a0
    800042fa:	dea43423          	sd	a0,-536(s0)
    800042fe:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004302:	ffffd097          	auipc	ra,0xffffd
    80004306:	b44080e7          	jalr	-1212(ra) # 80000e46 <myproc>
    8000430a:	84aa                	mv	s1,a0

  begin_op();
    8000430c:	fffff097          	auipc	ra,0xfffff
    80004310:	3be080e7          	jalr	958(ra) # 800036ca <begin_op>

  if((ip = namei(path)) == 0){
    80004314:	854a                	mv	a0,s2
    80004316:	fffff097          	auipc	ra,0xfffff
    8000431a:	194080e7          	jalr	404(ra) # 800034aa <namei>
    8000431e:	c93d                	beqz	a0,80004394 <exec+0xc4>
    80004320:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004322:	fffff097          	auipc	ra,0xfffff
    80004326:	9cc080e7          	jalr	-1588(ra) # 80002cee <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000432a:	04000713          	li	a4,64
    8000432e:	4681                	li	a3,0
    80004330:	e5040613          	addi	a2,s0,-432
    80004334:	4581                	li	a1,0
    80004336:	8556                	mv	a0,s5
    80004338:	fffff097          	auipc	ra,0xfffff
    8000433c:	c6a080e7          	jalr	-918(ra) # 80002fa2 <readi>
    80004340:	04000793          	li	a5,64
    80004344:	00f51a63          	bne	a0,a5,80004358 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004348:	e5042703          	lw	a4,-432(s0)
    8000434c:	464c47b7          	lui	a5,0x464c4
    80004350:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004354:	04f70663          	beq	a4,a5,800043a0 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004358:	8556                	mv	a0,s5
    8000435a:	fffff097          	auipc	ra,0xfffff
    8000435e:	bf6080e7          	jalr	-1034(ra) # 80002f50 <iunlockput>
    end_op();
    80004362:	fffff097          	auipc	ra,0xfffff
    80004366:	3e6080e7          	jalr	998(ra) # 80003748 <end_op>
  }
  return -1;
    8000436a:	557d                	li	a0,-1
}
    8000436c:	21813083          	ld	ra,536(sp)
    80004370:	21013403          	ld	s0,528(sp)
    80004374:	20813483          	ld	s1,520(sp)
    80004378:	20013903          	ld	s2,512(sp)
    8000437c:	79fe                	ld	s3,504(sp)
    8000437e:	7a5e                	ld	s4,496(sp)
    80004380:	7abe                	ld	s5,488(sp)
    80004382:	7b1e                	ld	s6,480(sp)
    80004384:	6bfe                	ld	s7,472(sp)
    80004386:	6c5e                	ld	s8,464(sp)
    80004388:	6cbe                	ld	s9,456(sp)
    8000438a:	6d1e                	ld	s10,448(sp)
    8000438c:	7dfa                	ld	s11,440(sp)
    8000438e:	22010113          	addi	sp,sp,544
    80004392:	8082                	ret
    end_op();
    80004394:	fffff097          	auipc	ra,0xfffff
    80004398:	3b4080e7          	jalr	948(ra) # 80003748 <end_op>
    return -1;
    8000439c:	557d                	li	a0,-1
    8000439e:	b7f9                	j	8000436c <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800043a0:	8526                	mv	a0,s1
    800043a2:	ffffd097          	auipc	ra,0xffffd
    800043a6:	b68080e7          	jalr	-1176(ra) # 80000f0a <proc_pagetable>
    800043aa:	8b2a                	mv	s6,a0
    800043ac:	d555                	beqz	a0,80004358 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043ae:	e7042783          	lw	a5,-400(s0)
    800043b2:	e8845703          	lhu	a4,-376(s0)
    800043b6:	c735                	beqz	a4,80004422 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043b8:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043ba:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800043be:	6a05                	lui	s4,0x1
    800043c0:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800043c4:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800043c8:	6d85                	lui	s11,0x1
    800043ca:	7d7d                	lui	s10,0xfffff
    800043cc:	ac1d                	j	80004602 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800043ce:	00004517          	auipc	a0,0x4
    800043d2:	2b250513          	addi	a0,a0,690 # 80008680 <syscalls+0x2a0>
    800043d6:	00002097          	auipc	ra,0x2
    800043da:	d1c080e7          	jalr	-740(ra) # 800060f2 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800043de:	874a                	mv	a4,s2
    800043e0:	009c86bb          	addw	a3,s9,s1
    800043e4:	4581                	li	a1,0
    800043e6:	8556                	mv	a0,s5
    800043e8:	fffff097          	auipc	ra,0xfffff
    800043ec:	bba080e7          	jalr	-1094(ra) # 80002fa2 <readi>
    800043f0:	2501                	sext.w	a0,a0
    800043f2:	1aa91863          	bne	s2,a0,800045a2 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    800043f6:	009d84bb          	addw	s1,s11,s1
    800043fa:	013d09bb          	addw	s3,s10,s3
    800043fe:	1f74f263          	bgeu	s1,s7,800045e2 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004402:	02049593          	slli	a1,s1,0x20
    80004406:	9181                	srli	a1,a1,0x20
    80004408:	95e2                	add	a1,a1,s8
    8000440a:	855a                	mv	a0,s6
    8000440c:	ffffc097          	auipc	ra,0xffffc
    80004410:	0f4080e7          	jalr	244(ra) # 80000500 <walkaddr>
    80004414:	862a                	mv	a2,a0
    if(pa == 0)
    80004416:	dd45                	beqz	a0,800043ce <exec+0xfe>
      n = PGSIZE;
    80004418:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000441a:	fd49f2e3          	bgeu	s3,s4,800043de <exec+0x10e>
      n = sz - i;
    8000441e:	894e                	mv	s2,s3
    80004420:	bf7d                	j	800043de <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004422:	4481                	li	s1,0
  iunlockput(ip);
    80004424:	8556                	mv	a0,s5
    80004426:	fffff097          	auipc	ra,0xfffff
    8000442a:	b2a080e7          	jalr	-1238(ra) # 80002f50 <iunlockput>
  end_op();
    8000442e:	fffff097          	auipc	ra,0xfffff
    80004432:	31a080e7          	jalr	794(ra) # 80003748 <end_op>
  p = myproc();
    80004436:	ffffd097          	auipc	ra,0xffffd
    8000443a:	a10080e7          	jalr	-1520(ra) # 80000e46 <myproc>
    8000443e:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004440:	35053d03          	ld	s10,848(a0)
  sz = PGROUNDUP(sz);
    80004444:	6785                	lui	a5,0x1
    80004446:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004448:	97a6                	add	a5,a5,s1
    8000444a:	777d                	lui	a4,0xfffff
    8000444c:	8ff9                	and	a5,a5,a4
    8000444e:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004452:	6609                	lui	a2,0x2
    80004454:	963e                	add	a2,a2,a5
    80004456:	85be                	mv	a1,a5
    80004458:	855a                	mv	a0,s6
    8000445a:	ffffc097          	auipc	ra,0xffffc
    8000445e:	45a080e7          	jalr	1114(ra) # 800008b4 <uvmalloc>
    80004462:	8c2a                	mv	s8,a0
  ip = 0;
    80004464:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004466:	12050e63          	beqz	a0,800045a2 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000446a:	75f9                	lui	a1,0xffffe
    8000446c:	95aa                	add	a1,a1,a0
    8000446e:	855a                	mv	a0,s6
    80004470:	ffffc097          	auipc	ra,0xffffc
    80004474:	666080e7          	jalr	1638(ra) # 80000ad6 <uvmclear>
  stackbase = sp - PGSIZE;
    80004478:	7afd                	lui	s5,0xfffff
    8000447a:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000447c:	df043783          	ld	a5,-528(s0)
    80004480:	6388                	ld	a0,0(a5)
    80004482:	c925                	beqz	a0,800044f2 <exec+0x222>
    80004484:	e9040993          	addi	s3,s0,-368
    80004488:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000448c:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000448e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004490:	ffffc097          	auipc	ra,0xffffc
    80004494:	e66080e7          	jalr	-410(ra) # 800002f6 <strlen>
    80004498:	0015079b          	addiw	a5,a0,1
    8000449c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800044a0:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800044a4:	13596363          	bltu	s2,s5,800045ca <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800044a8:	df043d83          	ld	s11,-528(s0)
    800044ac:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800044b0:	8552                	mv	a0,s4
    800044b2:	ffffc097          	auipc	ra,0xffffc
    800044b6:	e44080e7          	jalr	-444(ra) # 800002f6 <strlen>
    800044ba:	0015069b          	addiw	a3,a0,1
    800044be:	8652                	mv	a2,s4
    800044c0:	85ca                	mv	a1,s2
    800044c2:	855a                	mv	a0,s6
    800044c4:	ffffc097          	auipc	ra,0xffffc
    800044c8:	644080e7          	jalr	1604(ra) # 80000b08 <copyout>
    800044cc:	10054363          	bltz	a0,800045d2 <exec+0x302>
    ustack[argc] = sp;
    800044d0:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800044d4:	0485                	addi	s1,s1,1
    800044d6:	008d8793          	addi	a5,s11,8
    800044da:	def43823          	sd	a5,-528(s0)
    800044de:	008db503          	ld	a0,8(s11)
    800044e2:	c911                	beqz	a0,800044f6 <exec+0x226>
    if(argc >= MAXARG)
    800044e4:	09a1                	addi	s3,s3,8
    800044e6:	fb3c95e3          	bne	s9,s3,80004490 <exec+0x1c0>
  sz = sz1;
    800044ea:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044ee:	4a81                	li	s5,0
    800044f0:	a84d                	j	800045a2 <exec+0x2d2>
  sp = sz;
    800044f2:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800044f4:	4481                	li	s1,0
  ustack[argc] = 0;
    800044f6:	00349793          	slli	a5,s1,0x3
    800044fa:	f9078793          	addi	a5,a5,-112
    800044fe:	97a2                	add	a5,a5,s0
    80004500:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004504:	00148693          	addi	a3,s1,1
    80004508:	068e                	slli	a3,a3,0x3
    8000450a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000450e:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004512:	01597663          	bgeu	s2,s5,8000451e <exec+0x24e>
  sz = sz1;
    80004516:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000451a:	4a81                	li	s5,0
    8000451c:	a059                	j	800045a2 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000451e:	e9040613          	addi	a2,s0,-368
    80004522:	85ca                	mv	a1,s2
    80004524:	855a                	mv	a0,s6
    80004526:	ffffc097          	auipc	ra,0xffffc
    8000452a:	5e2080e7          	jalr	1506(ra) # 80000b08 <copyout>
    8000452e:	0a054663          	bltz	a0,800045da <exec+0x30a>
  p->trapframe->a1 = sp;
    80004532:	360bb783          	ld	a5,864(s7)
    80004536:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000453a:	de843783          	ld	a5,-536(s0)
    8000453e:	0007c703          	lbu	a4,0(a5)
    80004542:	cf11                	beqz	a4,8000455e <exec+0x28e>
    80004544:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004546:	02f00693          	li	a3,47
    8000454a:	a039                	j	80004558 <exec+0x288>
      last = s+1;
    8000454c:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004550:	0785                	addi	a5,a5,1
    80004552:	fff7c703          	lbu	a4,-1(a5)
    80004556:	c701                	beqz	a4,8000455e <exec+0x28e>
    if(*s == '/')
    80004558:	fed71ce3          	bne	a4,a3,80004550 <exec+0x280>
    8000455c:	bfc5                	j	8000454c <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    8000455e:	4641                	li	a2,16
    80004560:	de843583          	ld	a1,-536(s0)
    80004564:	460b8513          	addi	a0,s7,1120
    80004568:	ffffc097          	auipc	ra,0xffffc
    8000456c:	d5c080e7          	jalr	-676(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004570:	358bb503          	ld	a0,856(s7)
  p->pagetable = pagetable;
    80004574:	356bbc23          	sd	s6,856(s7)
  p->sz = sz;
    80004578:	358bb823          	sd	s8,848(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000457c:	360bb783          	ld	a5,864(s7)
    80004580:	e6843703          	ld	a4,-408(s0)
    80004584:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004586:	360bb783          	ld	a5,864(s7)
    8000458a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000458e:	85ea                	mv	a1,s10
    80004590:	ffffd097          	auipc	ra,0xffffd
    80004594:	a16080e7          	jalr	-1514(ra) # 80000fa6 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004598:	0004851b          	sext.w	a0,s1
    8000459c:	bbc1                	j	8000436c <exec+0x9c>
    8000459e:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800045a2:	df843583          	ld	a1,-520(s0)
    800045a6:	855a                	mv	a0,s6
    800045a8:	ffffd097          	auipc	ra,0xffffd
    800045ac:	9fe080e7          	jalr	-1538(ra) # 80000fa6 <proc_freepagetable>
  if(ip){
    800045b0:	da0a94e3          	bnez	s5,80004358 <exec+0x88>
  return -1;
    800045b4:	557d                	li	a0,-1
    800045b6:	bb5d                	j	8000436c <exec+0x9c>
    800045b8:	de943c23          	sd	s1,-520(s0)
    800045bc:	b7dd                	j	800045a2 <exec+0x2d2>
    800045be:	de943c23          	sd	s1,-520(s0)
    800045c2:	b7c5                	j	800045a2 <exec+0x2d2>
    800045c4:	de943c23          	sd	s1,-520(s0)
    800045c8:	bfe9                	j	800045a2 <exec+0x2d2>
  sz = sz1;
    800045ca:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045ce:	4a81                	li	s5,0
    800045d0:	bfc9                	j	800045a2 <exec+0x2d2>
  sz = sz1;
    800045d2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045d6:	4a81                	li	s5,0
    800045d8:	b7e9                	j	800045a2 <exec+0x2d2>
  sz = sz1;
    800045da:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045de:	4a81                	li	s5,0
    800045e0:	b7c9                	j	800045a2 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800045e2:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045e6:	e0843783          	ld	a5,-504(s0)
    800045ea:	0017869b          	addiw	a3,a5,1
    800045ee:	e0d43423          	sd	a3,-504(s0)
    800045f2:	e0043783          	ld	a5,-512(s0)
    800045f6:	0387879b          	addiw	a5,a5,56
    800045fa:	e8845703          	lhu	a4,-376(s0)
    800045fe:	e2e6d3e3          	bge	a3,a4,80004424 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004602:	2781                	sext.w	a5,a5
    80004604:	e0f43023          	sd	a5,-512(s0)
    80004608:	03800713          	li	a4,56
    8000460c:	86be                	mv	a3,a5
    8000460e:	e1840613          	addi	a2,s0,-488
    80004612:	4581                	li	a1,0
    80004614:	8556                	mv	a0,s5
    80004616:	fffff097          	auipc	ra,0xfffff
    8000461a:	98c080e7          	jalr	-1652(ra) # 80002fa2 <readi>
    8000461e:	03800793          	li	a5,56
    80004622:	f6f51ee3          	bne	a0,a5,8000459e <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    80004626:	e1842783          	lw	a5,-488(s0)
    8000462a:	4705                	li	a4,1
    8000462c:	fae79de3          	bne	a5,a4,800045e6 <exec+0x316>
    if(ph.memsz < ph.filesz)
    80004630:	e4043603          	ld	a2,-448(s0)
    80004634:	e3843783          	ld	a5,-456(s0)
    80004638:	f8f660e3          	bltu	a2,a5,800045b8 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000463c:	e2843783          	ld	a5,-472(s0)
    80004640:	963e                	add	a2,a2,a5
    80004642:	f6f66ee3          	bltu	a2,a5,800045be <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004646:	85a6                	mv	a1,s1
    80004648:	855a                	mv	a0,s6
    8000464a:	ffffc097          	auipc	ra,0xffffc
    8000464e:	26a080e7          	jalr	618(ra) # 800008b4 <uvmalloc>
    80004652:	dea43c23          	sd	a0,-520(s0)
    80004656:	d53d                	beqz	a0,800045c4 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    80004658:	e2843c03          	ld	s8,-472(s0)
    8000465c:	de043783          	ld	a5,-544(s0)
    80004660:	00fc77b3          	and	a5,s8,a5
    80004664:	ff9d                	bnez	a5,800045a2 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004666:	e2042c83          	lw	s9,-480(s0)
    8000466a:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000466e:	f60b8ae3          	beqz	s7,800045e2 <exec+0x312>
    80004672:	89de                	mv	s3,s7
    80004674:	4481                	li	s1,0
    80004676:	b371                	j	80004402 <exec+0x132>

0000000080004678 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004678:	7179                	addi	sp,sp,-48
    8000467a:	f406                	sd	ra,40(sp)
    8000467c:	f022                	sd	s0,32(sp)
    8000467e:	ec26                	sd	s1,24(sp)
    80004680:	e84a                	sd	s2,16(sp)
    80004682:	1800                	addi	s0,sp,48
    80004684:	892e                	mv	s2,a1
    80004686:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004688:	fdc40593          	addi	a1,s0,-36
    8000468c:	ffffe097          	auipc	ra,0xffffe
    80004690:	ae6080e7          	jalr	-1306(ra) # 80002172 <argint>
    80004694:	04054063          	bltz	a0,800046d4 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004698:	fdc42703          	lw	a4,-36(s0)
    8000469c:	47bd                	li	a5,15
    8000469e:	02e7ed63          	bltu	a5,a4,800046d8 <argfd+0x60>
    800046a2:	ffffc097          	auipc	ra,0xffffc
    800046a6:	7a4080e7          	jalr	1956(ra) # 80000e46 <myproc>
    800046aa:	fdc42703          	lw	a4,-36(s0)
    800046ae:	07a70793          	addi	a5,a4,122 # fffffffffffff07a <end+0xffffffff7ffcce3a>
    800046b2:	078e                	slli	a5,a5,0x3
    800046b4:	953e                	add	a0,a0,a5
    800046b6:	651c                	ld	a5,8(a0)
    800046b8:	c395                	beqz	a5,800046dc <argfd+0x64>
    return -1;
  if(pfd)
    800046ba:	00090463          	beqz	s2,800046c2 <argfd+0x4a>
    *pfd = fd;
    800046be:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046c2:	4501                	li	a0,0
  if(pf)
    800046c4:	c091                	beqz	s1,800046c8 <argfd+0x50>
    *pf = f;
    800046c6:	e09c                	sd	a5,0(s1)
}
    800046c8:	70a2                	ld	ra,40(sp)
    800046ca:	7402                	ld	s0,32(sp)
    800046cc:	64e2                	ld	s1,24(sp)
    800046ce:	6942                	ld	s2,16(sp)
    800046d0:	6145                	addi	sp,sp,48
    800046d2:	8082                	ret
    return -1;
    800046d4:	557d                	li	a0,-1
    800046d6:	bfcd                	j	800046c8 <argfd+0x50>
    return -1;
    800046d8:	557d                	li	a0,-1
    800046da:	b7fd                	j	800046c8 <argfd+0x50>
    800046dc:	557d                	li	a0,-1
    800046de:	b7ed                	j	800046c8 <argfd+0x50>

00000000800046e0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046e0:	1101                	addi	sp,sp,-32
    800046e2:	ec06                	sd	ra,24(sp)
    800046e4:	e822                	sd	s0,16(sp)
    800046e6:	e426                	sd	s1,8(sp)
    800046e8:	1000                	addi	s0,sp,32
    800046ea:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046ec:	ffffc097          	auipc	ra,0xffffc
    800046f0:	75a080e7          	jalr	1882(ra) # 80000e46 <myproc>
    800046f4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046f6:	3d850793          	addi	a5,a0,984
    800046fa:	4501                	li	a0,0
    800046fc:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046fe:	6398                	ld	a4,0(a5)
    80004700:	cb19                	beqz	a4,80004716 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004702:	2505                	addiw	a0,a0,1
    80004704:	07a1                	addi	a5,a5,8
    80004706:	fed51ce3          	bne	a0,a3,800046fe <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000470a:	557d                	li	a0,-1
}
    8000470c:	60e2                	ld	ra,24(sp)
    8000470e:	6442                	ld	s0,16(sp)
    80004710:	64a2                	ld	s1,8(sp)
    80004712:	6105                	addi	sp,sp,32
    80004714:	8082                	ret
      p->ofile[fd] = f;
    80004716:	07a50793          	addi	a5,a0,122
    8000471a:	078e                	slli	a5,a5,0x3
    8000471c:	963e                	add	a2,a2,a5
    8000471e:	e604                	sd	s1,8(a2)
      return fd;
    80004720:	b7f5                	j	8000470c <fdalloc+0x2c>

0000000080004722 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004722:	715d                	addi	sp,sp,-80
    80004724:	e486                	sd	ra,72(sp)
    80004726:	e0a2                	sd	s0,64(sp)
    80004728:	fc26                	sd	s1,56(sp)
    8000472a:	f84a                	sd	s2,48(sp)
    8000472c:	f44e                	sd	s3,40(sp)
    8000472e:	f052                	sd	s4,32(sp)
    80004730:	ec56                	sd	s5,24(sp)
    80004732:	0880                	addi	s0,sp,80
    80004734:	89ae                	mv	s3,a1
    80004736:	8ab2                	mv	s5,a2
    80004738:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000473a:	fb040593          	addi	a1,s0,-80
    8000473e:	fffff097          	auipc	ra,0xfffff
    80004742:	d8a080e7          	jalr	-630(ra) # 800034c8 <nameiparent>
    80004746:	892a                	mv	s2,a0
    80004748:	12050e63          	beqz	a0,80004884 <create+0x162>
    return 0;

  ilock(dp);
    8000474c:	ffffe097          	auipc	ra,0xffffe
    80004750:	5a2080e7          	jalr	1442(ra) # 80002cee <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004754:	4601                	li	a2,0
    80004756:	fb040593          	addi	a1,s0,-80
    8000475a:	854a                	mv	a0,s2
    8000475c:	fffff097          	auipc	ra,0xfffff
    80004760:	a76080e7          	jalr	-1418(ra) # 800031d2 <dirlookup>
    80004764:	84aa                	mv	s1,a0
    80004766:	c921                	beqz	a0,800047b6 <create+0x94>
    iunlockput(dp);
    80004768:	854a                	mv	a0,s2
    8000476a:	ffffe097          	auipc	ra,0xffffe
    8000476e:	7e6080e7          	jalr	2022(ra) # 80002f50 <iunlockput>
    ilock(ip);
    80004772:	8526                	mv	a0,s1
    80004774:	ffffe097          	auipc	ra,0xffffe
    80004778:	57a080e7          	jalr	1402(ra) # 80002cee <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000477c:	2981                	sext.w	s3,s3
    8000477e:	4789                	li	a5,2
    80004780:	02f99463          	bne	s3,a5,800047a8 <create+0x86>
    80004784:	0444d783          	lhu	a5,68(s1)
    80004788:	37f9                	addiw	a5,a5,-2
    8000478a:	17c2                	slli	a5,a5,0x30
    8000478c:	93c1                	srli	a5,a5,0x30
    8000478e:	4705                	li	a4,1
    80004790:	00f76c63          	bltu	a4,a5,800047a8 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004794:	8526                	mv	a0,s1
    80004796:	60a6                	ld	ra,72(sp)
    80004798:	6406                	ld	s0,64(sp)
    8000479a:	74e2                	ld	s1,56(sp)
    8000479c:	7942                	ld	s2,48(sp)
    8000479e:	79a2                	ld	s3,40(sp)
    800047a0:	7a02                	ld	s4,32(sp)
    800047a2:	6ae2                	ld	s5,24(sp)
    800047a4:	6161                	addi	sp,sp,80
    800047a6:	8082                	ret
    iunlockput(ip);
    800047a8:	8526                	mv	a0,s1
    800047aa:	ffffe097          	auipc	ra,0xffffe
    800047ae:	7a6080e7          	jalr	1958(ra) # 80002f50 <iunlockput>
    return 0;
    800047b2:	4481                	li	s1,0
    800047b4:	b7c5                	j	80004794 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800047b6:	85ce                	mv	a1,s3
    800047b8:	00092503          	lw	a0,0(s2)
    800047bc:	ffffe097          	auipc	ra,0xffffe
    800047c0:	398080e7          	jalr	920(ra) # 80002b54 <ialloc>
    800047c4:	84aa                	mv	s1,a0
    800047c6:	c521                	beqz	a0,8000480e <create+0xec>
  ilock(ip);
    800047c8:	ffffe097          	auipc	ra,0xffffe
    800047cc:	526080e7          	jalr	1318(ra) # 80002cee <ilock>
  ip->major = major;
    800047d0:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800047d4:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800047d8:	4a05                	li	s4,1
    800047da:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800047de:	8526                	mv	a0,s1
    800047e0:	ffffe097          	auipc	ra,0xffffe
    800047e4:	442080e7          	jalr	1090(ra) # 80002c22 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047e8:	2981                	sext.w	s3,s3
    800047ea:	03498a63          	beq	s3,s4,8000481e <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800047ee:	40d0                	lw	a2,4(s1)
    800047f0:	fb040593          	addi	a1,s0,-80
    800047f4:	854a                	mv	a0,s2
    800047f6:	fffff097          	auipc	ra,0xfffff
    800047fa:	bf2080e7          	jalr	-1038(ra) # 800033e8 <dirlink>
    800047fe:	06054b63          	bltz	a0,80004874 <create+0x152>
  iunlockput(dp);
    80004802:	854a                	mv	a0,s2
    80004804:	ffffe097          	auipc	ra,0xffffe
    80004808:	74c080e7          	jalr	1868(ra) # 80002f50 <iunlockput>
  return ip;
    8000480c:	b761                	j	80004794 <create+0x72>
    panic("create: ialloc");
    8000480e:	00004517          	auipc	a0,0x4
    80004812:	e9250513          	addi	a0,a0,-366 # 800086a0 <syscalls+0x2c0>
    80004816:	00002097          	auipc	ra,0x2
    8000481a:	8dc080e7          	jalr	-1828(ra) # 800060f2 <panic>
    dp->nlink++;  // for ".."
    8000481e:	04a95783          	lhu	a5,74(s2)
    80004822:	2785                	addiw	a5,a5,1
    80004824:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004828:	854a                	mv	a0,s2
    8000482a:	ffffe097          	auipc	ra,0xffffe
    8000482e:	3f8080e7          	jalr	1016(ra) # 80002c22 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004832:	40d0                	lw	a2,4(s1)
    80004834:	00004597          	auipc	a1,0x4
    80004838:	e7c58593          	addi	a1,a1,-388 # 800086b0 <syscalls+0x2d0>
    8000483c:	8526                	mv	a0,s1
    8000483e:	fffff097          	auipc	ra,0xfffff
    80004842:	baa080e7          	jalr	-1110(ra) # 800033e8 <dirlink>
    80004846:	00054f63          	bltz	a0,80004864 <create+0x142>
    8000484a:	00492603          	lw	a2,4(s2)
    8000484e:	00004597          	auipc	a1,0x4
    80004852:	e6a58593          	addi	a1,a1,-406 # 800086b8 <syscalls+0x2d8>
    80004856:	8526                	mv	a0,s1
    80004858:	fffff097          	auipc	ra,0xfffff
    8000485c:	b90080e7          	jalr	-1136(ra) # 800033e8 <dirlink>
    80004860:	f80557e3          	bgez	a0,800047ee <create+0xcc>
      panic("create dots");
    80004864:	00004517          	auipc	a0,0x4
    80004868:	e5c50513          	addi	a0,a0,-420 # 800086c0 <syscalls+0x2e0>
    8000486c:	00002097          	auipc	ra,0x2
    80004870:	886080e7          	jalr	-1914(ra) # 800060f2 <panic>
    panic("create: dirlink");
    80004874:	00004517          	auipc	a0,0x4
    80004878:	e5c50513          	addi	a0,a0,-420 # 800086d0 <syscalls+0x2f0>
    8000487c:	00002097          	auipc	ra,0x2
    80004880:	876080e7          	jalr	-1930(ra) # 800060f2 <panic>
    return 0;
    80004884:	84aa                	mv	s1,a0
    80004886:	b739                	j	80004794 <create+0x72>

0000000080004888 <sys_dup>:
{
    80004888:	7179                	addi	sp,sp,-48
    8000488a:	f406                	sd	ra,40(sp)
    8000488c:	f022                	sd	s0,32(sp)
    8000488e:	ec26                	sd	s1,24(sp)
    80004890:	e84a                	sd	s2,16(sp)
    80004892:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004894:	fd840613          	addi	a2,s0,-40
    80004898:	4581                	li	a1,0
    8000489a:	4501                	li	a0,0
    8000489c:	00000097          	auipc	ra,0x0
    800048a0:	ddc080e7          	jalr	-548(ra) # 80004678 <argfd>
    return -1;
    800048a4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800048a6:	02054363          	bltz	a0,800048cc <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800048aa:	fd843903          	ld	s2,-40(s0)
    800048ae:	854a                	mv	a0,s2
    800048b0:	00000097          	auipc	ra,0x0
    800048b4:	e30080e7          	jalr	-464(ra) # 800046e0 <fdalloc>
    800048b8:	84aa                	mv	s1,a0
    return -1;
    800048ba:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800048bc:	00054863          	bltz	a0,800048cc <sys_dup+0x44>
  filedup(f);
    800048c0:	854a                	mv	a0,s2
    800048c2:	fffff097          	auipc	ra,0xfffff
    800048c6:	282080e7          	jalr	642(ra) # 80003b44 <filedup>
  return fd;
    800048ca:	87a6                	mv	a5,s1
}
    800048cc:	853e                	mv	a0,a5
    800048ce:	70a2                	ld	ra,40(sp)
    800048d0:	7402                	ld	s0,32(sp)
    800048d2:	64e2                	ld	s1,24(sp)
    800048d4:	6942                	ld	s2,16(sp)
    800048d6:	6145                	addi	sp,sp,48
    800048d8:	8082                	ret

00000000800048da <sys_read>:
{
    800048da:	7179                	addi	sp,sp,-48
    800048dc:	f406                	sd	ra,40(sp)
    800048de:	f022                	sd	s0,32(sp)
    800048e0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048e2:	fe840613          	addi	a2,s0,-24
    800048e6:	4581                	li	a1,0
    800048e8:	4501                	li	a0,0
    800048ea:	00000097          	auipc	ra,0x0
    800048ee:	d8e080e7          	jalr	-626(ra) # 80004678 <argfd>
    return -1;
    800048f2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048f4:	04054163          	bltz	a0,80004936 <sys_read+0x5c>
    800048f8:	fe440593          	addi	a1,s0,-28
    800048fc:	4509                	li	a0,2
    800048fe:	ffffe097          	auipc	ra,0xffffe
    80004902:	874080e7          	jalr	-1932(ra) # 80002172 <argint>
    return -1;
    80004906:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004908:	02054763          	bltz	a0,80004936 <sys_read+0x5c>
    8000490c:	fd840593          	addi	a1,s0,-40
    80004910:	4505                	li	a0,1
    80004912:	ffffe097          	auipc	ra,0xffffe
    80004916:	882080e7          	jalr	-1918(ra) # 80002194 <argaddr>
    return -1;
    8000491a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000491c:	00054d63          	bltz	a0,80004936 <sys_read+0x5c>
  return fileread(f, p, n);
    80004920:	fe442603          	lw	a2,-28(s0)
    80004924:	fd843583          	ld	a1,-40(s0)
    80004928:	fe843503          	ld	a0,-24(s0)
    8000492c:	fffff097          	auipc	ra,0xfffff
    80004930:	3a4080e7          	jalr	932(ra) # 80003cd0 <fileread>
    80004934:	87aa                	mv	a5,a0
}
    80004936:	853e                	mv	a0,a5
    80004938:	70a2                	ld	ra,40(sp)
    8000493a:	7402                	ld	s0,32(sp)
    8000493c:	6145                	addi	sp,sp,48
    8000493e:	8082                	ret

0000000080004940 <sys_write>:
{
    80004940:	7179                	addi	sp,sp,-48
    80004942:	f406                	sd	ra,40(sp)
    80004944:	f022                	sd	s0,32(sp)
    80004946:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004948:	fe840613          	addi	a2,s0,-24
    8000494c:	4581                	li	a1,0
    8000494e:	4501                	li	a0,0
    80004950:	00000097          	auipc	ra,0x0
    80004954:	d28080e7          	jalr	-728(ra) # 80004678 <argfd>
    return -1;
    80004958:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000495a:	04054163          	bltz	a0,8000499c <sys_write+0x5c>
    8000495e:	fe440593          	addi	a1,s0,-28
    80004962:	4509                	li	a0,2
    80004964:	ffffe097          	auipc	ra,0xffffe
    80004968:	80e080e7          	jalr	-2034(ra) # 80002172 <argint>
    return -1;
    8000496c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000496e:	02054763          	bltz	a0,8000499c <sys_write+0x5c>
    80004972:	fd840593          	addi	a1,s0,-40
    80004976:	4505                	li	a0,1
    80004978:	ffffe097          	auipc	ra,0xffffe
    8000497c:	81c080e7          	jalr	-2020(ra) # 80002194 <argaddr>
    return -1;
    80004980:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004982:	00054d63          	bltz	a0,8000499c <sys_write+0x5c>
  return filewrite(f, p, n);
    80004986:	fe442603          	lw	a2,-28(s0)
    8000498a:	fd843583          	ld	a1,-40(s0)
    8000498e:	fe843503          	ld	a0,-24(s0)
    80004992:	fffff097          	auipc	ra,0xfffff
    80004996:	400080e7          	jalr	1024(ra) # 80003d92 <filewrite>
    8000499a:	87aa                	mv	a5,a0
}
    8000499c:	853e                	mv	a0,a5
    8000499e:	70a2                	ld	ra,40(sp)
    800049a0:	7402                	ld	s0,32(sp)
    800049a2:	6145                	addi	sp,sp,48
    800049a4:	8082                	ret

00000000800049a6 <sys_close>:
{
    800049a6:	1101                	addi	sp,sp,-32
    800049a8:	ec06                	sd	ra,24(sp)
    800049aa:	e822                	sd	s0,16(sp)
    800049ac:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800049ae:	fe040613          	addi	a2,s0,-32
    800049b2:	fec40593          	addi	a1,s0,-20
    800049b6:	4501                	li	a0,0
    800049b8:	00000097          	auipc	ra,0x0
    800049bc:	cc0080e7          	jalr	-832(ra) # 80004678 <argfd>
    return -1;
    800049c0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800049c2:	02054563          	bltz	a0,800049ec <sys_close+0x46>
  myproc()->ofile[fd] = 0;
    800049c6:	ffffc097          	auipc	ra,0xffffc
    800049ca:	480080e7          	jalr	1152(ra) # 80000e46 <myproc>
    800049ce:	fec42783          	lw	a5,-20(s0)
    800049d2:	07a78793          	addi	a5,a5,122
    800049d6:	078e                	slli	a5,a5,0x3
    800049d8:	953e                	add	a0,a0,a5
    800049da:	00053423          	sd	zero,8(a0)
  fileclose(f);
    800049de:	fe043503          	ld	a0,-32(s0)
    800049e2:	fffff097          	auipc	ra,0xfffff
    800049e6:	1b4080e7          	jalr	436(ra) # 80003b96 <fileclose>
  return 0;
    800049ea:	4781                	li	a5,0
}
    800049ec:	853e                	mv	a0,a5
    800049ee:	60e2                	ld	ra,24(sp)
    800049f0:	6442                	ld	s0,16(sp)
    800049f2:	6105                	addi	sp,sp,32
    800049f4:	8082                	ret

00000000800049f6 <sys_fstat>:
{
    800049f6:	1101                	addi	sp,sp,-32
    800049f8:	ec06                	sd	ra,24(sp)
    800049fa:	e822                	sd	s0,16(sp)
    800049fc:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049fe:	fe840613          	addi	a2,s0,-24
    80004a02:	4581                	li	a1,0
    80004a04:	4501                	li	a0,0
    80004a06:	00000097          	auipc	ra,0x0
    80004a0a:	c72080e7          	jalr	-910(ra) # 80004678 <argfd>
    return -1;
    80004a0e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a10:	02054563          	bltz	a0,80004a3a <sys_fstat+0x44>
    80004a14:	fe040593          	addi	a1,s0,-32
    80004a18:	4505                	li	a0,1
    80004a1a:	ffffd097          	auipc	ra,0xffffd
    80004a1e:	77a080e7          	jalr	1914(ra) # 80002194 <argaddr>
    return -1;
    80004a22:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a24:	00054b63          	bltz	a0,80004a3a <sys_fstat+0x44>
  return filestat(f, st);
    80004a28:	fe043583          	ld	a1,-32(s0)
    80004a2c:	fe843503          	ld	a0,-24(s0)
    80004a30:	fffff097          	auipc	ra,0xfffff
    80004a34:	22e080e7          	jalr	558(ra) # 80003c5e <filestat>
    80004a38:	87aa                	mv	a5,a0
}
    80004a3a:	853e                	mv	a0,a5
    80004a3c:	60e2                	ld	ra,24(sp)
    80004a3e:	6442                	ld	s0,16(sp)
    80004a40:	6105                	addi	sp,sp,32
    80004a42:	8082                	ret

0000000080004a44 <sys_link>:
{
    80004a44:	7169                	addi	sp,sp,-304
    80004a46:	f606                	sd	ra,296(sp)
    80004a48:	f222                	sd	s0,288(sp)
    80004a4a:	ee26                	sd	s1,280(sp)
    80004a4c:	ea4a                	sd	s2,272(sp)
    80004a4e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a50:	08000613          	li	a2,128
    80004a54:	ed040593          	addi	a1,s0,-304
    80004a58:	4501                	li	a0,0
    80004a5a:	ffffd097          	auipc	ra,0xffffd
    80004a5e:	75c080e7          	jalr	1884(ra) # 800021b6 <argstr>
    return -1;
    80004a62:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a64:	10054e63          	bltz	a0,80004b80 <sys_link+0x13c>
    80004a68:	08000613          	li	a2,128
    80004a6c:	f5040593          	addi	a1,s0,-176
    80004a70:	4505                	li	a0,1
    80004a72:	ffffd097          	auipc	ra,0xffffd
    80004a76:	744080e7          	jalr	1860(ra) # 800021b6 <argstr>
    return -1;
    80004a7a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a7c:	10054263          	bltz	a0,80004b80 <sys_link+0x13c>
  begin_op();
    80004a80:	fffff097          	auipc	ra,0xfffff
    80004a84:	c4a080e7          	jalr	-950(ra) # 800036ca <begin_op>
  if((ip = namei(old)) == 0){
    80004a88:	ed040513          	addi	a0,s0,-304
    80004a8c:	fffff097          	auipc	ra,0xfffff
    80004a90:	a1e080e7          	jalr	-1506(ra) # 800034aa <namei>
    80004a94:	84aa                	mv	s1,a0
    80004a96:	c551                	beqz	a0,80004b22 <sys_link+0xde>
  ilock(ip);
    80004a98:	ffffe097          	auipc	ra,0xffffe
    80004a9c:	256080e7          	jalr	598(ra) # 80002cee <ilock>
  if(ip->type == T_DIR){
    80004aa0:	04449703          	lh	a4,68(s1)
    80004aa4:	4785                	li	a5,1
    80004aa6:	08f70463          	beq	a4,a5,80004b2e <sys_link+0xea>
  ip->nlink++;
    80004aaa:	04a4d783          	lhu	a5,74(s1)
    80004aae:	2785                	addiw	a5,a5,1
    80004ab0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ab4:	8526                	mv	a0,s1
    80004ab6:	ffffe097          	auipc	ra,0xffffe
    80004aba:	16c080e7          	jalr	364(ra) # 80002c22 <iupdate>
  iunlock(ip);
    80004abe:	8526                	mv	a0,s1
    80004ac0:	ffffe097          	auipc	ra,0xffffe
    80004ac4:	2f0080e7          	jalr	752(ra) # 80002db0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004ac8:	fd040593          	addi	a1,s0,-48
    80004acc:	f5040513          	addi	a0,s0,-176
    80004ad0:	fffff097          	auipc	ra,0xfffff
    80004ad4:	9f8080e7          	jalr	-1544(ra) # 800034c8 <nameiparent>
    80004ad8:	892a                	mv	s2,a0
    80004ada:	c935                	beqz	a0,80004b4e <sys_link+0x10a>
  ilock(dp);
    80004adc:	ffffe097          	auipc	ra,0xffffe
    80004ae0:	212080e7          	jalr	530(ra) # 80002cee <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004ae4:	00092703          	lw	a4,0(s2)
    80004ae8:	409c                	lw	a5,0(s1)
    80004aea:	04f71d63          	bne	a4,a5,80004b44 <sys_link+0x100>
    80004aee:	40d0                	lw	a2,4(s1)
    80004af0:	fd040593          	addi	a1,s0,-48
    80004af4:	854a                	mv	a0,s2
    80004af6:	fffff097          	auipc	ra,0xfffff
    80004afa:	8f2080e7          	jalr	-1806(ra) # 800033e8 <dirlink>
    80004afe:	04054363          	bltz	a0,80004b44 <sys_link+0x100>
  iunlockput(dp);
    80004b02:	854a                	mv	a0,s2
    80004b04:	ffffe097          	auipc	ra,0xffffe
    80004b08:	44c080e7          	jalr	1100(ra) # 80002f50 <iunlockput>
  iput(ip);
    80004b0c:	8526                	mv	a0,s1
    80004b0e:	ffffe097          	auipc	ra,0xffffe
    80004b12:	39a080e7          	jalr	922(ra) # 80002ea8 <iput>
  end_op();
    80004b16:	fffff097          	auipc	ra,0xfffff
    80004b1a:	c32080e7          	jalr	-974(ra) # 80003748 <end_op>
  return 0;
    80004b1e:	4781                	li	a5,0
    80004b20:	a085                	j	80004b80 <sys_link+0x13c>
    end_op();
    80004b22:	fffff097          	auipc	ra,0xfffff
    80004b26:	c26080e7          	jalr	-986(ra) # 80003748 <end_op>
    return -1;
    80004b2a:	57fd                	li	a5,-1
    80004b2c:	a891                	j	80004b80 <sys_link+0x13c>
    iunlockput(ip);
    80004b2e:	8526                	mv	a0,s1
    80004b30:	ffffe097          	auipc	ra,0xffffe
    80004b34:	420080e7          	jalr	1056(ra) # 80002f50 <iunlockput>
    end_op();
    80004b38:	fffff097          	auipc	ra,0xfffff
    80004b3c:	c10080e7          	jalr	-1008(ra) # 80003748 <end_op>
    return -1;
    80004b40:	57fd                	li	a5,-1
    80004b42:	a83d                	j	80004b80 <sys_link+0x13c>
    iunlockput(dp);
    80004b44:	854a                	mv	a0,s2
    80004b46:	ffffe097          	auipc	ra,0xffffe
    80004b4a:	40a080e7          	jalr	1034(ra) # 80002f50 <iunlockput>
  ilock(ip);
    80004b4e:	8526                	mv	a0,s1
    80004b50:	ffffe097          	auipc	ra,0xffffe
    80004b54:	19e080e7          	jalr	414(ra) # 80002cee <ilock>
  ip->nlink--;
    80004b58:	04a4d783          	lhu	a5,74(s1)
    80004b5c:	37fd                	addiw	a5,a5,-1
    80004b5e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b62:	8526                	mv	a0,s1
    80004b64:	ffffe097          	auipc	ra,0xffffe
    80004b68:	0be080e7          	jalr	190(ra) # 80002c22 <iupdate>
  iunlockput(ip);
    80004b6c:	8526                	mv	a0,s1
    80004b6e:	ffffe097          	auipc	ra,0xffffe
    80004b72:	3e2080e7          	jalr	994(ra) # 80002f50 <iunlockput>
  end_op();
    80004b76:	fffff097          	auipc	ra,0xfffff
    80004b7a:	bd2080e7          	jalr	-1070(ra) # 80003748 <end_op>
  return -1;
    80004b7e:	57fd                	li	a5,-1
}
    80004b80:	853e                	mv	a0,a5
    80004b82:	70b2                	ld	ra,296(sp)
    80004b84:	7412                	ld	s0,288(sp)
    80004b86:	64f2                	ld	s1,280(sp)
    80004b88:	6952                	ld	s2,272(sp)
    80004b8a:	6155                	addi	sp,sp,304
    80004b8c:	8082                	ret

0000000080004b8e <sys_unlink>:
{
    80004b8e:	7151                	addi	sp,sp,-240
    80004b90:	f586                	sd	ra,232(sp)
    80004b92:	f1a2                	sd	s0,224(sp)
    80004b94:	eda6                	sd	s1,216(sp)
    80004b96:	e9ca                	sd	s2,208(sp)
    80004b98:	e5ce                	sd	s3,200(sp)
    80004b9a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b9c:	08000613          	li	a2,128
    80004ba0:	f3040593          	addi	a1,s0,-208
    80004ba4:	4501                	li	a0,0
    80004ba6:	ffffd097          	auipc	ra,0xffffd
    80004baa:	610080e7          	jalr	1552(ra) # 800021b6 <argstr>
    80004bae:	18054163          	bltz	a0,80004d30 <sys_unlink+0x1a2>
  begin_op();
    80004bb2:	fffff097          	auipc	ra,0xfffff
    80004bb6:	b18080e7          	jalr	-1256(ra) # 800036ca <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004bba:	fb040593          	addi	a1,s0,-80
    80004bbe:	f3040513          	addi	a0,s0,-208
    80004bc2:	fffff097          	auipc	ra,0xfffff
    80004bc6:	906080e7          	jalr	-1786(ra) # 800034c8 <nameiparent>
    80004bca:	84aa                	mv	s1,a0
    80004bcc:	c979                	beqz	a0,80004ca2 <sys_unlink+0x114>
  ilock(dp);
    80004bce:	ffffe097          	auipc	ra,0xffffe
    80004bd2:	120080e7          	jalr	288(ra) # 80002cee <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004bd6:	00004597          	auipc	a1,0x4
    80004bda:	ada58593          	addi	a1,a1,-1318 # 800086b0 <syscalls+0x2d0>
    80004bde:	fb040513          	addi	a0,s0,-80
    80004be2:	ffffe097          	auipc	ra,0xffffe
    80004be6:	5d6080e7          	jalr	1494(ra) # 800031b8 <namecmp>
    80004bea:	14050a63          	beqz	a0,80004d3e <sys_unlink+0x1b0>
    80004bee:	00004597          	auipc	a1,0x4
    80004bf2:	aca58593          	addi	a1,a1,-1334 # 800086b8 <syscalls+0x2d8>
    80004bf6:	fb040513          	addi	a0,s0,-80
    80004bfa:	ffffe097          	auipc	ra,0xffffe
    80004bfe:	5be080e7          	jalr	1470(ra) # 800031b8 <namecmp>
    80004c02:	12050e63          	beqz	a0,80004d3e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004c06:	f2c40613          	addi	a2,s0,-212
    80004c0a:	fb040593          	addi	a1,s0,-80
    80004c0e:	8526                	mv	a0,s1
    80004c10:	ffffe097          	auipc	ra,0xffffe
    80004c14:	5c2080e7          	jalr	1474(ra) # 800031d2 <dirlookup>
    80004c18:	892a                	mv	s2,a0
    80004c1a:	12050263          	beqz	a0,80004d3e <sys_unlink+0x1b0>
  ilock(ip);
    80004c1e:	ffffe097          	auipc	ra,0xffffe
    80004c22:	0d0080e7          	jalr	208(ra) # 80002cee <ilock>
  if(ip->nlink < 1)
    80004c26:	04a91783          	lh	a5,74(s2)
    80004c2a:	08f05263          	blez	a5,80004cae <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c2e:	04491703          	lh	a4,68(s2)
    80004c32:	4785                	li	a5,1
    80004c34:	08f70563          	beq	a4,a5,80004cbe <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004c38:	4641                	li	a2,16
    80004c3a:	4581                	li	a1,0
    80004c3c:	fc040513          	addi	a0,s0,-64
    80004c40:	ffffb097          	auipc	ra,0xffffb
    80004c44:	53a080e7          	jalr	1338(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c48:	4741                	li	a4,16
    80004c4a:	f2c42683          	lw	a3,-212(s0)
    80004c4e:	fc040613          	addi	a2,s0,-64
    80004c52:	4581                	li	a1,0
    80004c54:	8526                	mv	a0,s1
    80004c56:	ffffe097          	auipc	ra,0xffffe
    80004c5a:	444080e7          	jalr	1092(ra) # 8000309a <writei>
    80004c5e:	47c1                	li	a5,16
    80004c60:	0af51563          	bne	a0,a5,80004d0a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004c64:	04491703          	lh	a4,68(s2)
    80004c68:	4785                	li	a5,1
    80004c6a:	0af70863          	beq	a4,a5,80004d1a <sys_unlink+0x18c>
  iunlockput(dp);
    80004c6e:	8526                	mv	a0,s1
    80004c70:	ffffe097          	auipc	ra,0xffffe
    80004c74:	2e0080e7          	jalr	736(ra) # 80002f50 <iunlockput>
  ip->nlink--;
    80004c78:	04a95783          	lhu	a5,74(s2)
    80004c7c:	37fd                	addiw	a5,a5,-1
    80004c7e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c82:	854a                	mv	a0,s2
    80004c84:	ffffe097          	auipc	ra,0xffffe
    80004c88:	f9e080e7          	jalr	-98(ra) # 80002c22 <iupdate>
  iunlockput(ip);
    80004c8c:	854a                	mv	a0,s2
    80004c8e:	ffffe097          	auipc	ra,0xffffe
    80004c92:	2c2080e7          	jalr	706(ra) # 80002f50 <iunlockput>
  end_op();
    80004c96:	fffff097          	auipc	ra,0xfffff
    80004c9a:	ab2080e7          	jalr	-1358(ra) # 80003748 <end_op>
  return 0;
    80004c9e:	4501                	li	a0,0
    80004ca0:	a84d                	j	80004d52 <sys_unlink+0x1c4>
    end_op();
    80004ca2:	fffff097          	auipc	ra,0xfffff
    80004ca6:	aa6080e7          	jalr	-1370(ra) # 80003748 <end_op>
    return -1;
    80004caa:	557d                	li	a0,-1
    80004cac:	a05d                	j	80004d52 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004cae:	00004517          	auipc	a0,0x4
    80004cb2:	a3250513          	addi	a0,a0,-1486 # 800086e0 <syscalls+0x300>
    80004cb6:	00001097          	auipc	ra,0x1
    80004cba:	43c080e7          	jalr	1084(ra) # 800060f2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cbe:	04c92703          	lw	a4,76(s2)
    80004cc2:	02000793          	li	a5,32
    80004cc6:	f6e7f9e3          	bgeu	a5,a4,80004c38 <sys_unlink+0xaa>
    80004cca:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cce:	4741                	li	a4,16
    80004cd0:	86ce                	mv	a3,s3
    80004cd2:	f1840613          	addi	a2,s0,-232
    80004cd6:	4581                	li	a1,0
    80004cd8:	854a                	mv	a0,s2
    80004cda:	ffffe097          	auipc	ra,0xffffe
    80004cde:	2c8080e7          	jalr	712(ra) # 80002fa2 <readi>
    80004ce2:	47c1                	li	a5,16
    80004ce4:	00f51b63          	bne	a0,a5,80004cfa <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ce8:	f1845783          	lhu	a5,-232(s0)
    80004cec:	e7a1                	bnez	a5,80004d34 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cee:	29c1                	addiw	s3,s3,16
    80004cf0:	04c92783          	lw	a5,76(s2)
    80004cf4:	fcf9ede3          	bltu	s3,a5,80004cce <sys_unlink+0x140>
    80004cf8:	b781                	j	80004c38 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004cfa:	00004517          	auipc	a0,0x4
    80004cfe:	9fe50513          	addi	a0,a0,-1538 # 800086f8 <syscalls+0x318>
    80004d02:	00001097          	auipc	ra,0x1
    80004d06:	3f0080e7          	jalr	1008(ra) # 800060f2 <panic>
    panic("unlink: writei");
    80004d0a:	00004517          	auipc	a0,0x4
    80004d0e:	a0650513          	addi	a0,a0,-1530 # 80008710 <syscalls+0x330>
    80004d12:	00001097          	auipc	ra,0x1
    80004d16:	3e0080e7          	jalr	992(ra) # 800060f2 <panic>
    dp->nlink--;
    80004d1a:	04a4d783          	lhu	a5,74(s1)
    80004d1e:	37fd                	addiw	a5,a5,-1
    80004d20:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d24:	8526                	mv	a0,s1
    80004d26:	ffffe097          	auipc	ra,0xffffe
    80004d2a:	efc080e7          	jalr	-260(ra) # 80002c22 <iupdate>
    80004d2e:	b781                	j	80004c6e <sys_unlink+0xe0>
    return -1;
    80004d30:	557d                	li	a0,-1
    80004d32:	a005                	j	80004d52 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004d34:	854a                	mv	a0,s2
    80004d36:	ffffe097          	auipc	ra,0xffffe
    80004d3a:	21a080e7          	jalr	538(ra) # 80002f50 <iunlockput>
  iunlockput(dp);
    80004d3e:	8526                	mv	a0,s1
    80004d40:	ffffe097          	auipc	ra,0xffffe
    80004d44:	210080e7          	jalr	528(ra) # 80002f50 <iunlockput>
  end_op();
    80004d48:	fffff097          	auipc	ra,0xfffff
    80004d4c:	a00080e7          	jalr	-1536(ra) # 80003748 <end_op>
  return -1;
    80004d50:	557d                	li	a0,-1
}
    80004d52:	70ae                	ld	ra,232(sp)
    80004d54:	740e                	ld	s0,224(sp)
    80004d56:	64ee                	ld	s1,216(sp)
    80004d58:	694e                	ld	s2,208(sp)
    80004d5a:	69ae                	ld	s3,200(sp)
    80004d5c:	616d                	addi	sp,sp,240
    80004d5e:	8082                	ret

0000000080004d60 <sys_open>:

uint64
sys_open(void)
{
    80004d60:	7131                	addi	sp,sp,-192
    80004d62:	fd06                	sd	ra,184(sp)
    80004d64:	f922                	sd	s0,176(sp)
    80004d66:	f526                	sd	s1,168(sp)
    80004d68:	f14a                	sd	s2,160(sp)
    80004d6a:	ed4e                	sd	s3,152(sp)
    80004d6c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d6e:	08000613          	li	a2,128
    80004d72:	f5040593          	addi	a1,s0,-176
    80004d76:	4501                	li	a0,0
    80004d78:	ffffd097          	auipc	ra,0xffffd
    80004d7c:	43e080e7          	jalr	1086(ra) # 800021b6 <argstr>
    return -1;
    80004d80:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d82:	0c054163          	bltz	a0,80004e44 <sys_open+0xe4>
    80004d86:	f4c40593          	addi	a1,s0,-180
    80004d8a:	4505                	li	a0,1
    80004d8c:	ffffd097          	auipc	ra,0xffffd
    80004d90:	3e6080e7          	jalr	998(ra) # 80002172 <argint>
    80004d94:	0a054863          	bltz	a0,80004e44 <sys_open+0xe4>

  begin_op();
    80004d98:	fffff097          	auipc	ra,0xfffff
    80004d9c:	932080e7          	jalr	-1742(ra) # 800036ca <begin_op>

  if(omode & O_CREATE){
    80004da0:	f4c42783          	lw	a5,-180(s0)
    80004da4:	2007f793          	andi	a5,a5,512
    80004da8:	cbdd                	beqz	a5,80004e5e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004daa:	4681                	li	a3,0
    80004dac:	4601                	li	a2,0
    80004dae:	4589                	li	a1,2
    80004db0:	f5040513          	addi	a0,s0,-176
    80004db4:	00000097          	auipc	ra,0x0
    80004db8:	96e080e7          	jalr	-1682(ra) # 80004722 <create>
    80004dbc:	892a                	mv	s2,a0
    if(ip == 0){
    80004dbe:	c959                	beqz	a0,80004e54 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004dc0:	04491703          	lh	a4,68(s2)
    80004dc4:	478d                	li	a5,3
    80004dc6:	00f71763          	bne	a4,a5,80004dd4 <sys_open+0x74>
    80004dca:	04695703          	lhu	a4,70(s2)
    80004dce:	47a5                	li	a5,9
    80004dd0:	0ce7ec63          	bltu	a5,a4,80004ea8 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004dd4:	fffff097          	auipc	ra,0xfffff
    80004dd8:	d06080e7          	jalr	-762(ra) # 80003ada <filealloc>
    80004ddc:	89aa                	mv	s3,a0
    80004dde:	10050263          	beqz	a0,80004ee2 <sys_open+0x182>
    80004de2:	00000097          	auipc	ra,0x0
    80004de6:	8fe080e7          	jalr	-1794(ra) # 800046e0 <fdalloc>
    80004dea:	84aa                	mv	s1,a0
    80004dec:	0e054663          	bltz	a0,80004ed8 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004df0:	04491703          	lh	a4,68(s2)
    80004df4:	478d                	li	a5,3
    80004df6:	0cf70463          	beq	a4,a5,80004ebe <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004dfa:	4789                	li	a5,2
    80004dfc:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004e00:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004e04:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004e08:	f4c42783          	lw	a5,-180(s0)
    80004e0c:	0017c713          	xori	a4,a5,1
    80004e10:	8b05                	andi	a4,a4,1
    80004e12:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e16:	0037f713          	andi	a4,a5,3
    80004e1a:	00e03733          	snez	a4,a4
    80004e1e:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e22:	4007f793          	andi	a5,a5,1024
    80004e26:	c791                	beqz	a5,80004e32 <sys_open+0xd2>
    80004e28:	04491703          	lh	a4,68(s2)
    80004e2c:	4789                	li	a5,2
    80004e2e:	08f70f63          	beq	a4,a5,80004ecc <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004e32:	854a                	mv	a0,s2
    80004e34:	ffffe097          	auipc	ra,0xffffe
    80004e38:	f7c080e7          	jalr	-132(ra) # 80002db0 <iunlock>
  end_op();
    80004e3c:	fffff097          	auipc	ra,0xfffff
    80004e40:	90c080e7          	jalr	-1780(ra) # 80003748 <end_op>

  return fd;
}
    80004e44:	8526                	mv	a0,s1
    80004e46:	70ea                	ld	ra,184(sp)
    80004e48:	744a                	ld	s0,176(sp)
    80004e4a:	74aa                	ld	s1,168(sp)
    80004e4c:	790a                	ld	s2,160(sp)
    80004e4e:	69ea                	ld	s3,152(sp)
    80004e50:	6129                	addi	sp,sp,192
    80004e52:	8082                	ret
      end_op();
    80004e54:	fffff097          	auipc	ra,0xfffff
    80004e58:	8f4080e7          	jalr	-1804(ra) # 80003748 <end_op>
      return -1;
    80004e5c:	b7e5                	j	80004e44 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004e5e:	f5040513          	addi	a0,s0,-176
    80004e62:	ffffe097          	auipc	ra,0xffffe
    80004e66:	648080e7          	jalr	1608(ra) # 800034aa <namei>
    80004e6a:	892a                	mv	s2,a0
    80004e6c:	c905                	beqz	a0,80004e9c <sys_open+0x13c>
    ilock(ip);
    80004e6e:	ffffe097          	auipc	ra,0xffffe
    80004e72:	e80080e7          	jalr	-384(ra) # 80002cee <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e76:	04491703          	lh	a4,68(s2)
    80004e7a:	4785                	li	a5,1
    80004e7c:	f4f712e3          	bne	a4,a5,80004dc0 <sys_open+0x60>
    80004e80:	f4c42783          	lw	a5,-180(s0)
    80004e84:	dba1                	beqz	a5,80004dd4 <sys_open+0x74>
      iunlockput(ip);
    80004e86:	854a                	mv	a0,s2
    80004e88:	ffffe097          	auipc	ra,0xffffe
    80004e8c:	0c8080e7          	jalr	200(ra) # 80002f50 <iunlockput>
      end_op();
    80004e90:	fffff097          	auipc	ra,0xfffff
    80004e94:	8b8080e7          	jalr	-1864(ra) # 80003748 <end_op>
      return -1;
    80004e98:	54fd                	li	s1,-1
    80004e9a:	b76d                	j	80004e44 <sys_open+0xe4>
      end_op();
    80004e9c:	fffff097          	auipc	ra,0xfffff
    80004ea0:	8ac080e7          	jalr	-1876(ra) # 80003748 <end_op>
      return -1;
    80004ea4:	54fd                	li	s1,-1
    80004ea6:	bf79                	j	80004e44 <sys_open+0xe4>
    iunlockput(ip);
    80004ea8:	854a                	mv	a0,s2
    80004eaa:	ffffe097          	auipc	ra,0xffffe
    80004eae:	0a6080e7          	jalr	166(ra) # 80002f50 <iunlockput>
    end_op();
    80004eb2:	fffff097          	auipc	ra,0xfffff
    80004eb6:	896080e7          	jalr	-1898(ra) # 80003748 <end_op>
    return -1;
    80004eba:	54fd                	li	s1,-1
    80004ebc:	b761                	j	80004e44 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004ebe:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004ec2:	04691783          	lh	a5,70(s2)
    80004ec6:	02f99223          	sh	a5,36(s3)
    80004eca:	bf2d                	j	80004e04 <sys_open+0xa4>
    itrunc(ip);
    80004ecc:	854a                	mv	a0,s2
    80004ece:	ffffe097          	auipc	ra,0xffffe
    80004ed2:	f2e080e7          	jalr	-210(ra) # 80002dfc <itrunc>
    80004ed6:	bfb1                	j	80004e32 <sys_open+0xd2>
      fileclose(f);
    80004ed8:	854e                	mv	a0,s3
    80004eda:	fffff097          	auipc	ra,0xfffff
    80004ede:	cbc080e7          	jalr	-836(ra) # 80003b96 <fileclose>
    iunlockput(ip);
    80004ee2:	854a                	mv	a0,s2
    80004ee4:	ffffe097          	auipc	ra,0xffffe
    80004ee8:	06c080e7          	jalr	108(ra) # 80002f50 <iunlockput>
    end_op();
    80004eec:	fffff097          	auipc	ra,0xfffff
    80004ef0:	85c080e7          	jalr	-1956(ra) # 80003748 <end_op>
    return -1;
    80004ef4:	54fd                	li	s1,-1
    80004ef6:	b7b9                	j	80004e44 <sys_open+0xe4>

0000000080004ef8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ef8:	7175                	addi	sp,sp,-144
    80004efa:	e506                	sd	ra,136(sp)
    80004efc:	e122                	sd	s0,128(sp)
    80004efe:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f00:	ffffe097          	auipc	ra,0xffffe
    80004f04:	7ca080e7          	jalr	1994(ra) # 800036ca <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f08:	08000613          	li	a2,128
    80004f0c:	f7040593          	addi	a1,s0,-144
    80004f10:	4501                	li	a0,0
    80004f12:	ffffd097          	auipc	ra,0xffffd
    80004f16:	2a4080e7          	jalr	676(ra) # 800021b6 <argstr>
    80004f1a:	02054963          	bltz	a0,80004f4c <sys_mkdir+0x54>
    80004f1e:	4681                	li	a3,0
    80004f20:	4601                	li	a2,0
    80004f22:	4585                	li	a1,1
    80004f24:	f7040513          	addi	a0,s0,-144
    80004f28:	fffff097          	auipc	ra,0xfffff
    80004f2c:	7fa080e7          	jalr	2042(ra) # 80004722 <create>
    80004f30:	cd11                	beqz	a0,80004f4c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f32:	ffffe097          	auipc	ra,0xffffe
    80004f36:	01e080e7          	jalr	30(ra) # 80002f50 <iunlockput>
  end_op();
    80004f3a:	fffff097          	auipc	ra,0xfffff
    80004f3e:	80e080e7          	jalr	-2034(ra) # 80003748 <end_op>
  return 0;
    80004f42:	4501                	li	a0,0
}
    80004f44:	60aa                	ld	ra,136(sp)
    80004f46:	640a                	ld	s0,128(sp)
    80004f48:	6149                	addi	sp,sp,144
    80004f4a:	8082                	ret
    end_op();
    80004f4c:	ffffe097          	auipc	ra,0xffffe
    80004f50:	7fc080e7          	jalr	2044(ra) # 80003748 <end_op>
    return -1;
    80004f54:	557d                	li	a0,-1
    80004f56:	b7fd                	j	80004f44 <sys_mkdir+0x4c>

0000000080004f58 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f58:	7135                	addi	sp,sp,-160
    80004f5a:	ed06                	sd	ra,152(sp)
    80004f5c:	e922                	sd	s0,144(sp)
    80004f5e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f60:	ffffe097          	auipc	ra,0xffffe
    80004f64:	76a080e7          	jalr	1898(ra) # 800036ca <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f68:	08000613          	li	a2,128
    80004f6c:	f7040593          	addi	a1,s0,-144
    80004f70:	4501                	li	a0,0
    80004f72:	ffffd097          	auipc	ra,0xffffd
    80004f76:	244080e7          	jalr	580(ra) # 800021b6 <argstr>
    80004f7a:	04054a63          	bltz	a0,80004fce <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004f7e:	f6c40593          	addi	a1,s0,-148
    80004f82:	4505                	li	a0,1
    80004f84:	ffffd097          	auipc	ra,0xffffd
    80004f88:	1ee080e7          	jalr	494(ra) # 80002172 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f8c:	04054163          	bltz	a0,80004fce <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f90:	f6840593          	addi	a1,s0,-152
    80004f94:	4509                	li	a0,2
    80004f96:	ffffd097          	auipc	ra,0xffffd
    80004f9a:	1dc080e7          	jalr	476(ra) # 80002172 <argint>
     argint(1, &major) < 0 ||
    80004f9e:	02054863          	bltz	a0,80004fce <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004fa2:	f6841683          	lh	a3,-152(s0)
    80004fa6:	f6c41603          	lh	a2,-148(s0)
    80004faa:	458d                	li	a1,3
    80004fac:	f7040513          	addi	a0,s0,-144
    80004fb0:	fffff097          	auipc	ra,0xfffff
    80004fb4:	772080e7          	jalr	1906(ra) # 80004722 <create>
     argint(2, &minor) < 0 ||
    80004fb8:	c919                	beqz	a0,80004fce <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fba:	ffffe097          	auipc	ra,0xffffe
    80004fbe:	f96080e7          	jalr	-106(ra) # 80002f50 <iunlockput>
  end_op();
    80004fc2:	ffffe097          	auipc	ra,0xffffe
    80004fc6:	786080e7          	jalr	1926(ra) # 80003748 <end_op>
  return 0;
    80004fca:	4501                	li	a0,0
    80004fcc:	a031                	j	80004fd8 <sys_mknod+0x80>
    end_op();
    80004fce:	ffffe097          	auipc	ra,0xffffe
    80004fd2:	77a080e7          	jalr	1914(ra) # 80003748 <end_op>
    return -1;
    80004fd6:	557d                	li	a0,-1
}
    80004fd8:	60ea                	ld	ra,152(sp)
    80004fda:	644a                	ld	s0,144(sp)
    80004fdc:	610d                	addi	sp,sp,160
    80004fde:	8082                	ret

0000000080004fe0 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fe0:	7135                	addi	sp,sp,-160
    80004fe2:	ed06                	sd	ra,152(sp)
    80004fe4:	e922                	sd	s0,144(sp)
    80004fe6:	e526                	sd	s1,136(sp)
    80004fe8:	e14a                	sd	s2,128(sp)
    80004fea:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004fec:	ffffc097          	auipc	ra,0xffffc
    80004ff0:	e5a080e7          	jalr	-422(ra) # 80000e46 <myproc>
    80004ff4:	892a                	mv	s2,a0
  
  begin_op();
    80004ff6:	ffffe097          	auipc	ra,0xffffe
    80004ffa:	6d4080e7          	jalr	1748(ra) # 800036ca <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ffe:	08000613          	li	a2,128
    80005002:	f6040593          	addi	a1,s0,-160
    80005006:	4501                	li	a0,0
    80005008:	ffffd097          	auipc	ra,0xffffd
    8000500c:	1ae080e7          	jalr	430(ra) # 800021b6 <argstr>
    80005010:	04054b63          	bltz	a0,80005066 <sys_chdir+0x86>
    80005014:	f6040513          	addi	a0,s0,-160
    80005018:	ffffe097          	auipc	ra,0xffffe
    8000501c:	492080e7          	jalr	1170(ra) # 800034aa <namei>
    80005020:	84aa                	mv	s1,a0
    80005022:	c131                	beqz	a0,80005066 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005024:	ffffe097          	auipc	ra,0xffffe
    80005028:	cca080e7          	jalr	-822(ra) # 80002cee <ilock>
  if(ip->type != T_DIR){
    8000502c:	04449703          	lh	a4,68(s1)
    80005030:	4785                	li	a5,1
    80005032:	04f71063          	bne	a4,a5,80005072 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005036:	8526                	mv	a0,s1
    80005038:	ffffe097          	auipc	ra,0xffffe
    8000503c:	d78080e7          	jalr	-648(ra) # 80002db0 <iunlock>
  iput(p->cwd);
    80005040:	45893503          	ld	a0,1112(s2)
    80005044:	ffffe097          	auipc	ra,0xffffe
    80005048:	e64080e7          	jalr	-412(ra) # 80002ea8 <iput>
  end_op();
    8000504c:	ffffe097          	auipc	ra,0xffffe
    80005050:	6fc080e7          	jalr	1788(ra) # 80003748 <end_op>
  p->cwd = ip;
    80005054:	44993c23          	sd	s1,1112(s2)
  return 0;
    80005058:	4501                	li	a0,0
}
    8000505a:	60ea                	ld	ra,152(sp)
    8000505c:	644a                	ld	s0,144(sp)
    8000505e:	64aa                	ld	s1,136(sp)
    80005060:	690a                	ld	s2,128(sp)
    80005062:	610d                	addi	sp,sp,160
    80005064:	8082                	ret
    end_op();
    80005066:	ffffe097          	auipc	ra,0xffffe
    8000506a:	6e2080e7          	jalr	1762(ra) # 80003748 <end_op>
    return -1;
    8000506e:	557d                	li	a0,-1
    80005070:	b7ed                	j	8000505a <sys_chdir+0x7a>
    iunlockput(ip);
    80005072:	8526                	mv	a0,s1
    80005074:	ffffe097          	auipc	ra,0xffffe
    80005078:	edc080e7          	jalr	-292(ra) # 80002f50 <iunlockput>
    end_op();
    8000507c:	ffffe097          	auipc	ra,0xffffe
    80005080:	6cc080e7          	jalr	1740(ra) # 80003748 <end_op>
    return -1;
    80005084:	557d                	li	a0,-1
    80005086:	bfd1                	j	8000505a <sys_chdir+0x7a>

0000000080005088 <sys_exec>:

uint64
sys_exec(void)
{
    80005088:	7145                	addi	sp,sp,-464
    8000508a:	e786                	sd	ra,456(sp)
    8000508c:	e3a2                	sd	s0,448(sp)
    8000508e:	ff26                	sd	s1,440(sp)
    80005090:	fb4a                	sd	s2,432(sp)
    80005092:	f74e                	sd	s3,424(sp)
    80005094:	f352                	sd	s4,416(sp)
    80005096:	ef56                	sd	s5,408(sp)
    80005098:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000509a:	08000613          	li	a2,128
    8000509e:	f4040593          	addi	a1,s0,-192
    800050a2:	4501                	li	a0,0
    800050a4:	ffffd097          	auipc	ra,0xffffd
    800050a8:	112080e7          	jalr	274(ra) # 800021b6 <argstr>
    return -1;
    800050ac:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800050ae:	0c054b63          	bltz	a0,80005184 <sys_exec+0xfc>
    800050b2:	e3840593          	addi	a1,s0,-456
    800050b6:	4505                	li	a0,1
    800050b8:	ffffd097          	auipc	ra,0xffffd
    800050bc:	0dc080e7          	jalr	220(ra) # 80002194 <argaddr>
    800050c0:	0c054263          	bltz	a0,80005184 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    800050c4:	10000613          	li	a2,256
    800050c8:	4581                	li	a1,0
    800050ca:	e4040513          	addi	a0,s0,-448
    800050ce:	ffffb097          	auipc	ra,0xffffb
    800050d2:	0ac080e7          	jalr	172(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800050d6:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800050da:	89a6                	mv	s3,s1
    800050dc:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800050de:	02000a13          	li	s4,32
    800050e2:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050e6:	00391513          	slli	a0,s2,0x3
    800050ea:	e3040593          	addi	a1,s0,-464
    800050ee:	e3843783          	ld	a5,-456(s0)
    800050f2:	953e                	add	a0,a0,a5
    800050f4:	ffffd097          	auipc	ra,0xffffd
    800050f8:	fde080e7          	jalr	-34(ra) # 800020d2 <fetchaddr>
    800050fc:	02054a63          	bltz	a0,80005130 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005100:	e3043783          	ld	a5,-464(s0)
    80005104:	c3b9                	beqz	a5,8000514a <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005106:	ffffb097          	auipc	ra,0xffffb
    8000510a:	014080e7          	jalr	20(ra) # 8000011a <kalloc>
    8000510e:	85aa                	mv	a1,a0
    80005110:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005114:	cd11                	beqz	a0,80005130 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005116:	6605                	lui	a2,0x1
    80005118:	e3043503          	ld	a0,-464(s0)
    8000511c:	ffffd097          	auipc	ra,0xffffd
    80005120:	00c080e7          	jalr	12(ra) # 80002128 <fetchstr>
    80005124:	00054663          	bltz	a0,80005130 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005128:	0905                	addi	s2,s2,1
    8000512a:	09a1                	addi	s3,s3,8
    8000512c:	fb491be3          	bne	s2,s4,800050e2 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005130:	f4040913          	addi	s2,s0,-192
    80005134:	6088                	ld	a0,0(s1)
    80005136:	c531                	beqz	a0,80005182 <sys_exec+0xfa>
    kfree(argv[i]);
    80005138:	ffffb097          	auipc	ra,0xffffb
    8000513c:	ee4080e7          	jalr	-284(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005140:	04a1                	addi	s1,s1,8
    80005142:	ff2499e3          	bne	s1,s2,80005134 <sys_exec+0xac>
  return -1;
    80005146:	597d                	li	s2,-1
    80005148:	a835                	j	80005184 <sys_exec+0xfc>
      argv[i] = 0;
    8000514a:	0a8e                	slli	s5,s5,0x3
    8000514c:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffccd80>
    80005150:	00878ab3          	add	s5,a5,s0
    80005154:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005158:	e4040593          	addi	a1,s0,-448
    8000515c:	f4040513          	addi	a0,s0,-192
    80005160:	fffff097          	auipc	ra,0xfffff
    80005164:	170080e7          	jalr	368(ra) # 800042d0 <exec>
    80005168:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000516a:	f4040993          	addi	s3,s0,-192
    8000516e:	6088                	ld	a0,0(s1)
    80005170:	c911                	beqz	a0,80005184 <sys_exec+0xfc>
    kfree(argv[i]);
    80005172:	ffffb097          	auipc	ra,0xffffb
    80005176:	eaa080e7          	jalr	-342(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000517a:	04a1                	addi	s1,s1,8
    8000517c:	ff3499e3          	bne	s1,s3,8000516e <sys_exec+0xe6>
    80005180:	a011                	j	80005184 <sys_exec+0xfc>
  return -1;
    80005182:	597d                	li	s2,-1
}
    80005184:	854a                	mv	a0,s2
    80005186:	60be                	ld	ra,456(sp)
    80005188:	641e                	ld	s0,448(sp)
    8000518a:	74fa                	ld	s1,440(sp)
    8000518c:	795a                	ld	s2,432(sp)
    8000518e:	79ba                	ld	s3,424(sp)
    80005190:	7a1a                	ld	s4,416(sp)
    80005192:	6afa                	ld	s5,408(sp)
    80005194:	6179                	addi	sp,sp,464
    80005196:	8082                	ret

0000000080005198 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005198:	7139                	addi	sp,sp,-64
    8000519a:	fc06                	sd	ra,56(sp)
    8000519c:	f822                	sd	s0,48(sp)
    8000519e:	f426                	sd	s1,40(sp)
    800051a0:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800051a2:	ffffc097          	auipc	ra,0xffffc
    800051a6:	ca4080e7          	jalr	-860(ra) # 80000e46 <myproc>
    800051aa:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800051ac:	fd840593          	addi	a1,s0,-40
    800051b0:	4501                	li	a0,0
    800051b2:	ffffd097          	auipc	ra,0xffffd
    800051b6:	fe2080e7          	jalr	-30(ra) # 80002194 <argaddr>
    return -1;
    800051ba:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800051bc:	0e054563          	bltz	a0,800052a6 <sys_pipe+0x10e>
  if(pipealloc(&rf, &wf) < 0)
    800051c0:	fc840593          	addi	a1,s0,-56
    800051c4:	fd040513          	addi	a0,s0,-48
    800051c8:	fffff097          	auipc	ra,0xfffff
    800051cc:	de4080e7          	jalr	-540(ra) # 80003fac <pipealloc>
    return -1;
    800051d0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800051d2:	0c054a63          	bltz	a0,800052a6 <sys_pipe+0x10e>
  fd0 = -1;
    800051d6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800051da:	fd043503          	ld	a0,-48(s0)
    800051de:	fffff097          	auipc	ra,0xfffff
    800051e2:	502080e7          	jalr	1282(ra) # 800046e0 <fdalloc>
    800051e6:	fca42223          	sw	a0,-60(s0)
    800051ea:	0a054163          	bltz	a0,8000528c <sys_pipe+0xf4>
    800051ee:	fc843503          	ld	a0,-56(s0)
    800051f2:	fffff097          	auipc	ra,0xfffff
    800051f6:	4ee080e7          	jalr	1262(ra) # 800046e0 <fdalloc>
    800051fa:	fca42023          	sw	a0,-64(s0)
    800051fe:	06054d63          	bltz	a0,80005278 <sys_pipe+0xe0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005202:	4691                	li	a3,4
    80005204:	fc440613          	addi	a2,s0,-60
    80005208:	fd843583          	ld	a1,-40(s0)
    8000520c:	3584b503          	ld	a0,856(s1)
    80005210:	ffffc097          	auipc	ra,0xffffc
    80005214:	8f8080e7          	jalr	-1800(ra) # 80000b08 <copyout>
    80005218:	02054163          	bltz	a0,8000523a <sys_pipe+0xa2>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000521c:	4691                	li	a3,4
    8000521e:	fc040613          	addi	a2,s0,-64
    80005222:	fd843583          	ld	a1,-40(s0)
    80005226:	0591                	addi	a1,a1,4
    80005228:	3584b503          	ld	a0,856(s1)
    8000522c:	ffffc097          	auipc	ra,0xffffc
    80005230:	8dc080e7          	jalr	-1828(ra) # 80000b08 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005234:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005236:	06055863          	bgez	a0,800052a6 <sys_pipe+0x10e>
    p->ofile[fd0] = 0;
    8000523a:	fc442783          	lw	a5,-60(s0)
    8000523e:	07a78793          	addi	a5,a5,122
    80005242:	078e                	slli	a5,a5,0x3
    80005244:	97a6                	add	a5,a5,s1
    80005246:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    8000524a:	fc042783          	lw	a5,-64(s0)
    8000524e:	07a78793          	addi	a5,a5,122
    80005252:	078e                	slli	a5,a5,0x3
    80005254:	00f48533          	add	a0,s1,a5
    80005258:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    8000525c:	fd043503          	ld	a0,-48(s0)
    80005260:	fffff097          	auipc	ra,0xfffff
    80005264:	936080e7          	jalr	-1738(ra) # 80003b96 <fileclose>
    fileclose(wf);
    80005268:	fc843503          	ld	a0,-56(s0)
    8000526c:	fffff097          	auipc	ra,0xfffff
    80005270:	92a080e7          	jalr	-1750(ra) # 80003b96 <fileclose>
    return -1;
    80005274:	57fd                	li	a5,-1
    80005276:	a805                	j	800052a6 <sys_pipe+0x10e>
    if(fd0 >= 0)
    80005278:	fc442783          	lw	a5,-60(s0)
    8000527c:	0007c863          	bltz	a5,8000528c <sys_pipe+0xf4>
      p->ofile[fd0] = 0;
    80005280:	07a78793          	addi	a5,a5,122
    80005284:	078e                	slli	a5,a5,0x3
    80005286:	97a6                	add	a5,a5,s1
    80005288:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    8000528c:	fd043503          	ld	a0,-48(s0)
    80005290:	fffff097          	auipc	ra,0xfffff
    80005294:	906080e7          	jalr	-1786(ra) # 80003b96 <fileclose>
    fileclose(wf);
    80005298:	fc843503          	ld	a0,-56(s0)
    8000529c:	fffff097          	auipc	ra,0xfffff
    800052a0:	8fa080e7          	jalr	-1798(ra) # 80003b96 <fileclose>
    return -1;
    800052a4:	57fd                	li	a5,-1
}
    800052a6:	853e                	mv	a0,a5
    800052a8:	70e2                	ld	ra,56(sp)
    800052aa:	7442                	ld	s0,48(sp)
    800052ac:	74a2                	ld	s1,40(sp)
    800052ae:	6121                	addi	sp,sp,64
    800052b0:	8082                	ret

00000000800052b2 <sys_mmap>:

 uint64 sys_mmap(void)
 {
    800052b2:	715d                	addi	sp,sp,-80
    800052b4:	e486                	sd	ra,72(sp)
    800052b6:	e0a2                	sd	s0,64(sp)
    800052b8:	fc26                	sd	s1,56(sp)
    800052ba:	f84a                	sd	s2,48(sp)
    800052bc:	f44e                	sd	s3,40(sp)
    800052be:	0880                	addi	s0,sp,80
   // to gain the arguments , file and proc
   uint64 addr;
   int len , prot , flags , fd , off;
   if( argaddr( 0 , &addr ) < 0 || argint( 1 , &len ) < 0 || argint( 2 , &prot ) < 0 || argint( 3 , &flags ) < 0 || argint( 4 , &fd ) < 0 || argint( 5 , &off ) < 0 )
    800052c0:	fc840593          	addi	a1,s0,-56
    800052c4:	4501                	li	a0,0
    800052c6:	ffffd097          	auipc	ra,0xffffd
    800052ca:	ece080e7          	jalr	-306(ra) # 80002194 <argaddr>
    800052ce:	10054b63          	bltz	a0,800053e4 <sys_mmap+0x132>
    800052d2:	fc440593          	addi	a1,s0,-60
    800052d6:	4505                	li	a0,1
    800052d8:	ffffd097          	auipc	ra,0xffffd
    800052dc:	e9a080e7          	jalr	-358(ra) # 80002172 <argint>
    800052e0:	10054a63          	bltz	a0,800053f4 <sys_mmap+0x142>
    800052e4:	fc040593          	addi	a1,s0,-64
    800052e8:	4509                	li	a0,2
    800052ea:	ffffd097          	auipc	ra,0xffffd
    800052ee:	e88080e7          	jalr	-376(ra) # 80002172 <argint>
    800052f2:	10054363          	bltz	a0,800053f8 <sys_mmap+0x146>
    800052f6:	fbc40593          	addi	a1,s0,-68
    800052fa:	450d                	li	a0,3
    800052fc:	ffffd097          	auipc	ra,0xffffd
    80005300:	e76080e7          	jalr	-394(ra) # 80002172 <argint>
    80005304:	0e054c63          	bltz	a0,800053fc <sys_mmap+0x14a>
    80005308:	fb840593          	addi	a1,s0,-72
    8000530c:	4511                	li	a0,4
    8000530e:	ffffd097          	auipc	ra,0xffffd
    80005312:	e64080e7          	jalr	-412(ra) # 80002172 <argint>
    80005316:	0e054563          	bltz	a0,80005400 <sys_mmap+0x14e>
    8000531a:	fb440593          	addi	a1,s0,-76
    8000531e:	4515                	li	a0,5
    80005320:	ffffd097          	auipc	ra,0xffffd
    80005324:	e52080e7          	jalr	-430(ra) # 80002172 <argint>
    80005328:	0c054e63          	bltz	a0,80005404 <sys_mmap+0x152>
     return -1;

   struct proc* p = myproc();
    8000532c:	ffffc097          	auipc	ra,0xffffc
    80005330:	b1a080e7          	jalr	-1254(ra) # 80000e46 <myproc>
    80005334:	892a                	mv	s2,a0
   struct file* f = p->ofile[fd];
    80005336:	fb842783          	lw	a5,-72(s0)
    8000533a:	07a78793          	addi	a5,a5,122
    8000533e:	078e                	slli	a5,a5,0x3
    80005340:	97aa                	add	a5,a5,a0
    80005342:	6788                	ld	a0,8(a5)
   
   // to ensure the prot
   if( ( flags == MAP_SHARED && f->writable == 0 && (prot&PROT_WRITE)) )
    80005344:	fbc42603          	lw	a2,-68(s0)
    80005348:	4785                	li	a5,1
    8000534a:	02f60563          	beq	a2,a5,80005374 <sys_mmap+0xc2>
     return -1;
  
   // to find a empty vma and init it
   int idx;
   for( idx = 0 ; idx < VMA_MAX ; idx++ )
    8000534e:	01890793          	addi	a5,s2,24
 {
    80005352:	4481                	li	s1,0
   for( idx = 0 ; idx < VMA_MAX ; idx++ )
    80005354:	46c1                	li	a3,16
     if( p->vma[idx].valid == 0 )
    80005356:	4398                	lw	a4,0(a5)
    80005358:	c71d                	beqz	a4,80005386 <sys_mmap+0xd4>
   for( idx = 0 ; idx < VMA_MAX ; idx++ )
    8000535a:	2485                	addiw	s1,s1,1
    8000535c:	03078793          	addi	a5,a5,48
    80005360:	fed49be3          	bne	s1,a3,80005356 <sys_mmap+0xa4>
       break;

   if( idx == VMA_MAX )
     panic("no empty vma field");
    80005364:	00003517          	auipc	a0,0x3
    80005368:	3bc50513          	addi	a0,a0,956 # 80008720 <syscalls+0x340>
    8000536c:	00001097          	auipc	ra,0x1
    80005370:	d86080e7          	jalr	-634(ra) # 800060f2 <panic>
   if( ( flags == MAP_SHARED && f->writable == 0 && (prot&PROT_WRITE)) )
    80005374:	00954783          	lbu	a5,9(a0)
    80005378:	fbf9                	bnez	a5,8000534e <sys_mmap+0x9c>
    8000537a:	fc042783          	lw	a5,-64(s0)
    8000537e:	8b89                	andi	a5,a5,2
    80005380:	d7f9                	beqz	a5,8000534e <sys_mmap+0x9c>
     return -1;
    80005382:	557d                	li	a0,-1
    80005384:	a08d                	j	800053e6 <sys_mmap+0x134>
   if( idx == VMA_MAX )
    80005386:	47c1                	li	a5,16
    80005388:	fcf48ee3          	beq	s1,a5,80005364 <sys_mmap+0xb2>
   
   struct VMA* vp = &p->vma[idx];
   vp->valid = 1;
    8000538c:	00149993          	slli	s3,s1,0x1
    80005390:	009987b3          	add	a5,s3,s1
    80005394:	0792                	slli	a5,a5,0x4
    80005396:	97ca                	add	a5,a5,s2
    80005398:	4705                	li	a4,1
    8000539a:	cf98                	sw	a4,24(a5)
   vp->len = len;
    8000539c:	fc442703          	lw	a4,-60(s0)
    800053a0:	d798                	sw	a4,40(a5)
   vp->flags = flags;
    800053a2:	db90                	sw	a2,48(a5)
   vp->off = off;
    800053a4:	fb442703          	lw	a4,-76(s0)
    800053a8:	dbd8                	sw	a4,52(a5)
   vp->prot = prot;
    800053aa:	fc042703          	lw	a4,-64(s0)
    800053ae:	d7d8                	sw	a4,44(a5)
   vp->f = f;
    800053b0:	00148713          	addi	a4,s1,1
    800053b4:	00171793          	slli	a5,a4,0x1
    800053b8:	97ba                	add	a5,a5,a4
    800053ba:	0792                	slli	a5,a5,0x4
    800053bc:	97ca                	add	a5,a5,s2
    800053be:	e788                	sd	a0,8(a5)
   filedup( f );  //increase the ref of the file
    800053c0:	ffffe097          	auipc	ra,0xffffe
    800053c4:	784080e7          	jalr	1924(ra) # 80003b44 <filedup>

   vp->addr = (p->maxaddr-=len);  // asign a useable virtual address to the vma field , and maintain the maxaddr
    800053c8:	fc442703          	lw	a4,-60(s0)
    800053cc:	31893783          	ld	a5,792(s2)
    800053d0:	40e78533          	sub	a0,a5,a4
    800053d4:	30a93c23          	sd	a0,792(s2)
    800053d8:	99a6                	add	s3,s3,s1
    800053da:	0992                	slli	s3,s3,0x4
    800053dc:	994e                	add	s2,s2,s3
    800053de:	02a93023          	sd	a0,32(s2)
   return vp->addr;
    800053e2:	a011                	j	800053e6 <sys_mmap+0x134>
     return -1;
    800053e4:	557d                	li	a0,-1
 }
    800053e6:	60a6                	ld	ra,72(sp)
    800053e8:	6406                	ld	s0,64(sp)
    800053ea:	74e2                	ld	s1,56(sp)
    800053ec:	7942                	ld	s2,48(sp)
    800053ee:	79a2                	ld	s3,40(sp)
    800053f0:	6161                	addi	sp,sp,80
    800053f2:	8082                	ret
     return -1;
    800053f4:	557d                	li	a0,-1
    800053f6:	bfc5                	j	800053e6 <sys_mmap+0x134>
    800053f8:	557d                	li	a0,-1
    800053fa:	b7f5                	j	800053e6 <sys_mmap+0x134>
    800053fc:	557d                	li	a0,-1
    800053fe:	b7e5                	j	800053e6 <sys_mmap+0x134>
    80005400:	557d                	li	a0,-1
    80005402:	b7d5                	j	800053e6 <sys_mmap+0x134>
    80005404:	557d                	li	a0,-1
    80005406:	b7c5                	j	800053e6 <sys_mmap+0x134>

0000000080005408 <sys_munmap>:

 uint64 sys_munmap(void)
 {
    80005408:	7139                	addi	sp,sp,-64
    8000540a:	fc06                	sd	ra,56(sp)
    8000540c:	f822                	sd	s0,48(sp)
    8000540e:	f426                	sd	s1,40(sp)
    80005410:	f04a                	sd	s2,32(sp)
    80005412:	ec4e                	sd	s3,24(sp)
    80005414:	0080                	addi	s0,sp,64
   // to gain the arguments and proc
   uint64 addr;
   int len;
   if( argaddr( 0 , &addr ) < 0 || argint( 1 , &len ) < 0 )
    80005416:	fc840593          	addi	a1,s0,-56
    8000541a:	4501                	li	a0,0
    8000541c:	ffffd097          	auipc	ra,0xffffd
    80005420:	d78080e7          	jalr	-648(ra) # 80002194 <argaddr>
    80005424:	10054063          	bltz	a0,80005524 <sys_munmap+0x11c>
    80005428:	fc440593          	addi	a1,s0,-60
    8000542c:	4505                	li	a0,1
    8000542e:	ffffd097          	auipc	ra,0xffffd
    80005432:	d44080e7          	jalr	-700(ra) # 80002172 <argint>
    80005436:	0e054f63          	bltz	a0,80005534 <sys_munmap+0x12c>
     return -1;
   struct proc* p = myproc();
    8000543a:	ffffc097          	auipc	ra,0xffffc
    8000543e:	a0c080e7          	jalr	-1524(ra) # 80000e46 <myproc>
    80005442:	892a                	mv	s2,a0
 
   //to find the target vma
   struct VMA* vp = 0;
   for( int i=0 ; i<VMA_MAX ; i++ )
     if( p->vma[i].addr <= addr && addr < p->vma[i].addr + p->vma[i].len && p->vma[i].valid == 1 )
    80005444:	fc843583          	ld	a1,-56(s0)
    80005448:	01850793          	addi	a5,a0,24
   for( int i=0 ; i<VMA_MAX ; i++ )
    8000544c:	4481                	li	s1,0
     if( p->vma[i].addr <= addr && addr < p->vma[i].addr + p->vma[i].len && p->vma[i].valid == 1 )
    8000544e:	4505                	li	a0,1
   for( int i=0 ; i<VMA_MAX ; i++ )
    80005450:	4841                	li	a6,16
    80005452:	a031                	j	8000545e <sys_munmap+0x56>
    80005454:	2485                	addiw	s1,s1,1
    80005456:	03078793          	addi	a5,a5,48
    8000545a:	0d048f63          	beq	s1,a6,80005538 <sys_munmap+0x130>
     if( p->vma[i].addr <= addr && addr < p->vma[i].addr + p->vma[i].len && p->vma[i].valid == 1 )
    8000545e:	6798                	ld	a4,8(a5)
    80005460:	fee5eae3          	bltu	a1,a4,80005454 <sys_munmap+0x4c>
    80005464:	4b94                	lw	a3,16(a5)
    80005466:	9736                	add	a4,a4,a3
    80005468:	fee5f6e3          	bgeu	a1,a4,80005454 <sys_munmap+0x4c>
    8000546c:	4398                	lw	a4,0(a5)
    8000546e:	fea713e3          	bne	a4,a0,80005454 <sys_munmap+0x4c>
     }
   if( vp == 0 )
     panic("munmap no such vma");  
 
   // if the page has been mapped 
   if( walkaddr( p->pagetable , addr ) != 0)
    80005472:	35893503          	ld	a0,856(s2)
    80005476:	ffffb097          	auipc	ra,0xffffb
    8000547a:	08a080e7          	jalr	138(ra) # 80000500 <walkaddr>
    8000547e:	ed15                	bnez	a0,800054ba <sys_munmap+0xb2>
       filewriteoff( vp->f , addr , len , addr-vp->addr ); // this function is new
     uvmunmap( p->pagetable , addr , len/PGSIZE , 1 );   //unmap
     return 0;
   }
   // maintain the ref of file and the valid of the vma
   if( 0 == (vp->mapcnt -= len) )
    80005480:	00149793          	slli	a5,s1,0x1
    80005484:	97a6                	add	a5,a5,s1
    80005486:	0792                	slli	a5,a5,0x4
    80005488:	97ca                	add	a5,a5,s2
    8000548a:	fc442703          	lw	a4,-60(s0)
    8000548e:	0407b983          	ld	s3,64(a5)
    80005492:	40e989b3          	sub	s3,s3,a4
    80005496:	0537b023          	sd	s3,64(a5)
    8000549a:	08099663          	bnez	s3,80005526 <sys_munmap+0x11e>
   {
     fileclose( vp->f );
    8000549e:	7f88                	ld	a0,56(a5)
    800054a0:	ffffe097          	auipc	ra,0xffffe
    800054a4:	6f6080e7          	jalr	1782(ra) # 80003b96 <fileclose>
     vp->valid = 0;
    800054a8:	00149793          	slli	a5,s1,0x1
    800054ac:	97a6                	add	a5,a5,s1
    800054ae:	0792                	slli	a5,a5,0x4
    800054b0:	993e                	add	s2,s2,a5
    800054b2:	00092c23          	sw	zero,24(s2)
   }
   return 0;
    800054b6:	854e                	mv	a0,s3
    800054b8:	a0bd                	j	80005526 <sys_munmap+0x11e>
     if( vp->flags == MAP_SHARED )
    800054ba:	00149793          	slli	a5,s1,0x1
    800054be:	97a6                	add	a5,a5,s1
    800054c0:	0792                	slli	a5,a5,0x4
    800054c2:	97ca                	add	a5,a5,s2
    800054c4:	5b98                	lw	a4,48(a5)
    800054c6:	4785                	li	a5,1
    800054c8:	02f70663          	beq	a4,a5,800054f4 <sys_munmap+0xec>
     uvmunmap( p->pagetable , addr , len/PGSIZE , 1 );   //unmap
    800054cc:	fc442783          	lw	a5,-60(s0)
    800054d0:	41f7d61b          	sraiw	a2,a5,0x1f
    800054d4:	0146561b          	srliw	a2,a2,0x14
    800054d8:	9e3d                	addw	a2,a2,a5
    800054da:	4685                	li	a3,1
    800054dc:	40c6561b          	sraiw	a2,a2,0xc
    800054e0:	fc843583          	ld	a1,-56(s0)
    800054e4:	35893503          	ld	a0,856(s2)
    800054e8:	ffffb097          	auipc	ra,0xffffb
    800054ec:	220080e7          	jalr	544(ra) # 80000708 <uvmunmap>
     return 0;
    800054f0:	4501                	li	a0,0
    800054f2:	a815                	j	80005526 <sys_munmap+0x11e>
       filewriteoff( vp->f , addr , len , addr-vp->addr ); // this function is new
    800054f4:	fc843583          	ld	a1,-56(s0)
    800054f8:	00149793          	slli	a5,s1,0x1
    800054fc:	97a6                	add	a5,a5,s1
    800054fe:	0792                	slli	a5,a5,0x4
    80005500:	97ca                	add	a5,a5,s2
    80005502:	7394                	ld	a3,32(a5)
    80005504:	0485                	addi	s1,s1,1
    80005506:	00149793          	slli	a5,s1,0x1
    8000550a:	97a6                	add	a5,a5,s1
    8000550c:	0792                	slli	a5,a5,0x4
    8000550e:	97ca                	add	a5,a5,s2
    80005510:	40d586bb          	subw	a3,a1,a3
    80005514:	fc442603          	lw	a2,-60(s0)
    80005518:	6788                	ld	a0,8(a5)
    8000551a:	fffff097          	auipc	ra,0xfffff
    8000551e:	9ac080e7          	jalr	-1620(ra) # 80003ec6 <filewriteoff>
    80005522:	b76d                	j	800054cc <sys_munmap+0xc4>
     return -1;
    80005524:	557d                	li	a0,-1
    80005526:	70e2                	ld	ra,56(sp)
    80005528:	7442                	ld	s0,48(sp)
    8000552a:	74a2                	ld	s1,40(sp)
    8000552c:	7902                	ld	s2,32(sp)
    8000552e:	69e2                	ld	s3,24(sp)
    80005530:	6121                	addi	sp,sp,64
    80005532:	8082                	ret
     return -1;
    80005534:	557d                	li	a0,-1
    80005536:	bfc5                	j	80005526 <sys_munmap+0x11e>
     panic("munmap no such vma");  
    80005538:	00003517          	auipc	a0,0x3
    8000553c:	20050513          	addi	a0,a0,512 # 80008738 <syscalls+0x358>
    80005540:	00001097          	auipc	ra,0x1
    80005544:	bb2080e7          	jalr	-1102(ra) # 800060f2 <panic>
	...

0000000080005550 <kernelvec>:
    80005550:	7111                	addi	sp,sp,-256
    80005552:	e006                	sd	ra,0(sp)
    80005554:	e40a                	sd	sp,8(sp)
    80005556:	e80e                	sd	gp,16(sp)
    80005558:	ec12                	sd	tp,24(sp)
    8000555a:	f016                	sd	t0,32(sp)
    8000555c:	f41a                	sd	t1,40(sp)
    8000555e:	f81e                	sd	t2,48(sp)
    80005560:	fc22                	sd	s0,56(sp)
    80005562:	e0a6                	sd	s1,64(sp)
    80005564:	e4aa                	sd	a0,72(sp)
    80005566:	e8ae                	sd	a1,80(sp)
    80005568:	ecb2                	sd	a2,88(sp)
    8000556a:	f0b6                	sd	a3,96(sp)
    8000556c:	f4ba                	sd	a4,104(sp)
    8000556e:	f8be                	sd	a5,112(sp)
    80005570:	fcc2                	sd	a6,120(sp)
    80005572:	e146                	sd	a7,128(sp)
    80005574:	e54a                	sd	s2,136(sp)
    80005576:	e94e                	sd	s3,144(sp)
    80005578:	ed52                	sd	s4,152(sp)
    8000557a:	f156                	sd	s5,160(sp)
    8000557c:	f55a                	sd	s6,168(sp)
    8000557e:	f95e                	sd	s7,176(sp)
    80005580:	fd62                	sd	s8,184(sp)
    80005582:	e1e6                	sd	s9,192(sp)
    80005584:	e5ea                	sd	s10,200(sp)
    80005586:	e9ee                	sd	s11,208(sp)
    80005588:	edf2                	sd	t3,216(sp)
    8000558a:	f1f6                	sd	t4,224(sp)
    8000558c:	f5fa                	sd	t5,232(sp)
    8000558e:	f9fe                	sd	t6,240(sp)
    80005590:	a01fc0ef          	jal	ra,80001f90 <kerneltrap>
    80005594:	6082                	ld	ra,0(sp)
    80005596:	6122                	ld	sp,8(sp)
    80005598:	61c2                	ld	gp,16(sp)
    8000559a:	7282                	ld	t0,32(sp)
    8000559c:	7322                	ld	t1,40(sp)
    8000559e:	73c2                	ld	t2,48(sp)
    800055a0:	7462                	ld	s0,56(sp)
    800055a2:	6486                	ld	s1,64(sp)
    800055a4:	6526                	ld	a0,72(sp)
    800055a6:	65c6                	ld	a1,80(sp)
    800055a8:	6666                	ld	a2,88(sp)
    800055aa:	7686                	ld	a3,96(sp)
    800055ac:	7726                	ld	a4,104(sp)
    800055ae:	77c6                	ld	a5,112(sp)
    800055b0:	7866                	ld	a6,120(sp)
    800055b2:	688a                	ld	a7,128(sp)
    800055b4:	692a                	ld	s2,136(sp)
    800055b6:	69ca                	ld	s3,144(sp)
    800055b8:	6a6a                	ld	s4,152(sp)
    800055ba:	7a8a                	ld	s5,160(sp)
    800055bc:	7b2a                	ld	s6,168(sp)
    800055be:	7bca                	ld	s7,176(sp)
    800055c0:	7c6a                	ld	s8,184(sp)
    800055c2:	6c8e                	ld	s9,192(sp)
    800055c4:	6d2e                	ld	s10,200(sp)
    800055c6:	6dce                	ld	s11,208(sp)
    800055c8:	6e6e                	ld	t3,216(sp)
    800055ca:	7e8e                	ld	t4,224(sp)
    800055cc:	7f2e                	ld	t5,232(sp)
    800055ce:	7fce                	ld	t6,240(sp)
    800055d0:	6111                	addi	sp,sp,256
    800055d2:	10200073          	sret
    800055d6:	00000013          	nop
    800055da:	00000013          	nop
    800055de:	0001                	nop

00000000800055e0 <timervec>:
    800055e0:	34051573          	csrrw	a0,mscratch,a0
    800055e4:	e10c                	sd	a1,0(a0)
    800055e6:	e510                	sd	a2,8(a0)
    800055e8:	e914                	sd	a3,16(a0)
    800055ea:	6d0c                	ld	a1,24(a0)
    800055ec:	7110                	ld	a2,32(a0)
    800055ee:	6194                	ld	a3,0(a1)
    800055f0:	96b2                	add	a3,a3,a2
    800055f2:	e194                	sd	a3,0(a1)
    800055f4:	4589                	li	a1,2
    800055f6:	14459073          	csrw	sip,a1
    800055fa:	6914                	ld	a3,16(a0)
    800055fc:	6510                	ld	a2,8(a0)
    800055fe:	610c                	ld	a1,0(a0)
    80005600:	34051573          	csrrw	a0,mscratch,a0
    80005604:	30200073          	mret
	...

000000008000560a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000560a:	1141                	addi	sp,sp,-16
    8000560c:	e422                	sd	s0,8(sp)
    8000560e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005610:	0c0007b7          	lui	a5,0xc000
    80005614:	4705                	li	a4,1
    80005616:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005618:	c3d8                	sw	a4,4(a5)
}
    8000561a:	6422                	ld	s0,8(sp)
    8000561c:	0141                	addi	sp,sp,16
    8000561e:	8082                	ret

0000000080005620 <plicinithart>:

void
plicinithart(void)
{
    80005620:	1141                	addi	sp,sp,-16
    80005622:	e406                	sd	ra,8(sp)
    80005624:	e022                	sd	s0,0(sp)
    80005626:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005628:	ffffb097          	auipc	ra,0xffffb
    8000562c:	7f2080e7          	jalr	2034(ra) # 80000e1a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005630:	0085171b          	slliw	a4,a0,0x8
    80005634:	0c0027b7          	lui	a5,0xc002
    80005638:	97ba                	add	a5,a5,a4
    8000563a:	40200713          	li	a4,1026
    8000563e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005642:	00d5151b          	slliw	a0,a0,0xd
    80005646:	0c2017b7          	lui	a5,0xc201
    8000564a:	97aa                	add	a5,a5,a0
    8000564c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005650:	60a2                	ld	ra,8(sp)
    80005652:	6402                	ld	s0,0(sp)
    80005654:	0141                	addi	sp,sp,16
    80005656:	8082                	ret

0000000080005658 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005658:	1141                	addi	sp,sp,-16
    8000565a:	e406                	sd	ra,8(sp)
    8000565c:	e022                	sd	s0,0(sp)
    8000565e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005660:	ffffb097          	auipc	ra,0xffffb
    80005664:	7ba080e7          	jalr	1978(ra) # 80000e1a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005668:	00d5151b          	slliw	a0,a0,0xd
    8000566c:	0c2017b7          	lui	a5,0xc201
    80005670:	97aa                	add	a5,a5,a0
  return irq;
}
    80005672:	43c8                	lw	a0,4(a5)
    80005674:	60a2                	ld	ra,8(sp)
    80005676:	6402                	ld	s0,0(sp)
    80005678:	0141                	addi	sp,sp,16
    8000567a:	8082                	ret

000000008000567c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000567c:	1101                	addi	sp,sp,-32
    8000567e:	ec06                	sd	ra,24(sp)
    80005680:	e822                	sd	s0,16(sp)
    80005682:	e426                	sd	s1,8(sp)
    80005684:	1000                	addi	s0,sp,32
    80005686:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005688:	ffffb097          	auipc	ra,0xffffb
    8000568c:	792080e7          	jalr	1938(ra) # 80000e1a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005690:	00d5151b          	slliw	a0,a0,0xd
    80005694:	0c2017b7          	lui	a5,0xc201
    80005698:	97aa                	add	a5,a5,a0
    8000569a:	c3c4                	sw	s1,4(a5)
}
    8000569c:	60e2                	ld	ra,24(sp)
    8000569e:	6442                	ld	s0,16(sp)
    800056a0:	64a2                	ld	s1,8(sp)
    800056a2:	6105                	addi	sp,sp,32
    800056a4:	8082                	ret

00000000800056a6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800056a6:	1141                	addi	sp,sp,-16
    800056a8:	e406                	sd	ra,8(sp)
    800056aa:	e022                	sd	s0,0(sp)
    800056ac:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800056ae:	479d                	li	a5,7
    800056b0:	06a7c863          	blt	a5,a0,80005720 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800056b4:	00022717          	auipc	a4,0x22
    800056b8:	94c70713          	addi	a4,a4,-1716 # 80027000 <disk>
    800056bc:	972a                	add	a4,a4,a0
    800056be:	6789                	lui	a5,0x2
    800056c0:	97ba                	add	a5,a5,a4
    800056c2:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800056c6:	e7ad                	bnez	a5,80005730 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800056c8:	00451793          	slli	a5,a0,0x4
    800056cc:	00024717          	auipc	a4,0x24
    800056d0:	93470713          	addi	a4,a4,-1740 # 80029000 <disk+0x2000>
    800056d4:	6314                	ld	a3,0(a4)
    800056d6:	96be                	add	a3,a3,a5
    800056d8:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800056dc:	6314                	ld	a3,0(a4)
    800056de:	96be                	add	a3,a3,a5
    800056e0:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800056e4:	6314                	ld	a3,0(a4)
    800056e6:	96be                	add	a3,a3,a5
    800056e8:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800056ec:	6318                	ld	a4,0(a4)
    800056ee:	97ba                	add	a5,a5,a4
    800056f0:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800056f4:	00022717          	auipc	a4,0x22
    800056f8:	90c70713          	addi	a4,a4,-1780 # 80027000 <disk>
    800056fc:	972a                	add	a4,a4,a0
    800056fe:	6789                	lui	a5,0x2
    80005700:	97ba                	add	a5,a5,a4
    80005702:	4705                	li	a4,1
    80005704:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005708:	00024517          	auipc	a0,0x24
    8000570c:	91050513          	addi	a0,a0,-1776 # 80029018 <disk+0x2018>
    80005710:	ffffc097          	auipc	ra,0xffffc
    80005714:	020080e7          	jalr	32(ra) # 80001730 <wakeup>
}
    80005718:	60a2                	ld	ra,8(sp)
    8000571a:	6402                	ld	s0,0(sp)
    8000571c:	0141                	addi	sp,sp,16
    8000571e:	8082                	ret
    panic("free_desc 1");
    80005720:	00003517          	auipc	a0,0x3
    80005724:	03050513          	addi	a0,a0,48 # 80008750 <syscalls+0x370>
    80005728:	00001097          	auipc	ra,0x1
    8000572c:	9ca080e7          	jalr	-1590(ra) # 800060f2 <panic>
    panic("free_desc 2");
    80005730:	00003517          	auipc	a0,0x3
    80005734:	03050513          	addi	a0,a0,48 # 80008760 <syscalls+0x380>
    80005738:	00001097          	auipc	ra,0x1
    8000573c:	9ba080e7          	jalr	-1606(ra) # 800060f2 <panic>

0000000080005740 <virtio_disk_init>:
{
    80005740:	1101                	addi	sp,sp,-32
    80005742:	ec06                	sd	ra,24(sp)
    80005744:	e822                	sd	s0,16(sp)
    80005746:	e426                	sd	s1,8(sp)
    80005748:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000574a:	00003597          	auipc	a1,0x3
    8000574e:	02658593          	addi	a1,a1,38 # 80008770 <syscalls+0x390>
    80005752:	00024517          	auipc	a0,0x24
    80005756:	9d650513          	addi	a0,a0,-1578 # 80029128 <disk+0x2128>
    8000575a:	00001097          	auipc	ra,0x1
    8000575e:	e40080e7          	jalr	-448(ra) # 8000659a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005762:	100017b7          	lui	a5,0x10001
    80005766:	4398                	lw	a4,0(a5)
    80005768:	2701                	sext.w	a4,a4
    8000576a:	747277b7          	lui	a5,0x74727
    8000576e:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005772:	0ef71063          	bne	a4,a5,80005852 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005776:	100017b7          	lui	a5,0x10001
    8000577a:	43dc                	lw	a5,4(a5)
    8000577c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000577e:	4705                	li	a4,1
    80005780:	0ce79963          	bne	a5,a4,80005852 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005784:	100017b7          	lui	a5,0x10001
    80005788:	479c                	lw	a5,8(a5)
    8000578a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000578c:	4709                	li	a4,2
    8000578e:	0ce79263          	bne	a5,a4,80005852 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005792:	100017b7          	lui	a5,0x10001
    80005796:	47d8                	lw	a4,12(a5)
    80005798:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000579a:	554d47b7          	lui	a5,0x554d4
    8000579e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800057a2:	0af71863          	bne	a4,a5,80005852 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    800057a6:	100017b7          	lui	a5,0x10001
    800057aa:	4705                	li	a4,1
    800057ac:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800057ae:	470d                	li	a4,3
    800057b0:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800057b2:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800057b4:	c7ffe6b7          	lui	a3,0xc7ffe
    800057b8:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fcc51f>
    800057bc:	8f75                	and	a4,a4,a3
    800057be:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800057c0:	472d                	li	a4,11
    800057c2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800057c4:	473d                	li	a4,15
    800057c6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800057c8:	6705                	lui	a4,0x1
    800057ca:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800057cc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800057d0:	5bdc                	lw	a5,52(a5)
    800057d2:	2781                	sext.w	a5,a5
  if(max == 0)
    800057d4:	c7d9                	beqz	a5,80005862 <virtio_disk_init+0x122>
  if(max < NUM)
    800057d6:	471d                	li	a4,7
    800057d8:	08f77d63          	bgeu	a4,a5,80005872 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800057dc:	100014b7          	lui	s1,0x10001
    800057e0:	47a1                	li	a5,8
    800057e2:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800057e4:	6609                	lui	a2,0x2
    800057e6:	4581                	li	a1,0
    800057e8:	00022517          	auipc	a0,0x22
    800057ec:	81850513          	addi	a0,a0,-2024 # 80027000 <disk>
    800057f0:	ffffb097          	auipc	ra,0xffffb
    800057f4:	98a080e7          	jalr	-1654(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800057f8:	00022717          	auipc	a4,0x22
    800057fc:	80870713          	addi	a4,a4,-2040 # 80027000 <disk>
    80005800:	00c75793          	srli	a5,a4,0xc
    80005804:	2781                	sext.w	a5,a5
    80005806:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005808:	00023797          	auipc	a5,0x23
    8000580c:	7f878793          	addi	a5,a5,2040 # 80029000 <disk+0x2000>
    80005810:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005812:	00022717          	auipc	a4,0x22
    80005816:	86e70713          	addi	a4,a4,-1938 # 80027080 <disk+0x80>
    8000581a:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000581c:	00022717          	auipc	a4,0x22
    80005820:	7e470713          	addi	a4,a4,2020 # 80028000 <disk+0x1000>
    80005824:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005826:	4705                	li	a4,1
    80005828:	00e78c23          	sb	a4,24(a5)
    8000582c:	00e78ca3          	sb	a4,25(a5)
    80005830:	00e78d23          	sb	a4,26(a5)
    80005834:	00e78da3          	sb	a4,27(a5)
    80005838:	00e78e23          	sb	a4,28(a5)
    8000583c:	00e78ea3          	sb	a4,29(a5)
    80005840:	00e78f23          	sb	a4,30(a5)
    80005844:	00e78fa3          	sb	a4,31(a5)
}
    80005848:	60e2                	ld	ra,24(sp)
    8000584a:	6442                	ld	s0,16(sp)
    8000584c:	64a2                	ld	s1,8(sp)
    8000584e:	6105                	addi	sp,sp,32
    80005850:	8082                	ret
    panic("could not find virtio disk");
    80005852:	00003517          	auipc	a0,0x3
    80005856:	f2e50513          	addi	a0,a0,-210 # 80008780 <syscalls+0x3a0>
    8000585a:	00001097          	auipc	ra,0x1
    8000585e:	898080e7          	jalr	-1896(ra) # 800060f2 <panic>
    panic("virtio disk has no queue 0");
    80005862:	00003517          	auipc	a0,0x3
    80005866:	f3e50513          	addi	a0,a0,-194 # 800087a0 <syscalls+0x3c0>
    8000586a:	00001097          	auipc	ra,0x1
    8000586e:	888080e7          	jalr	-1912(ra) # 800060f2 <panic>
    panic("virtio disk max queue too short");
    80005872:	00003517          	auipc	a0,0x3
    80005876:	f4e50513          	addi	a0,a0,-178 # 800087c0 <syscalls+0x3e0>
    8000587a:	00001097          	auipc	ra,0x1
    8000587e:	878080e7          	jalr	-1928(ra) # 800060f2 <panic>

0000000080005882 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005882:	7119                	addi	sp,sp,-128
    80005884:	fc86                	sd	ra,120(sp)
    80005886:	f8a2                	sd	s0,112(sp)
    80005888:	f4a6                	sd	s1,104(sp)
    8000588a:	f0ca                	sd	s2,96(sp)
    8000588c:	ecce                	sd	s3,88(sp)
    8000588e:	e8d2                	sd	s4,80(sp)
    80005890:	e4d6                	sd	s5,72(sp)
    80005892:	e0da                	sd	s6,64(sp)
    80005894:	fc5e                	sd	s7,56(sp)
    80005896:	f862                	sd	s8,48(sp)
    80005898:	f466                	sd	s9,40(sp)
    8000589a:	f06a                	sd	s10,32(sp)
    8000589c:	ec6e                	sd	s11,24(sp)
    8000589e:	0100                	addi	s0,sp,128
    800058a0:	8aaa                	mv	s5,a0
    800058a2:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800058a4:	00c52c83          	lw	s9,12(a0)
    800058a8:	001c9c9b          	slliw	s9,s9,0x1
    800058ac:	1c82                	slli	s9,s9,0x20
    800058ae:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800058b2:	00024517          	auipc	a0,0x24
    800058b6:	87650513          	addi	a0,a0,-1930 # 80029128 <disk+0x2128>
    800058ba:	00001097          	auipc	ra,0x1
    800058be:	d70080e7          	jalr	-656(ra) # 8000662a <acquire>
  for(int i = 0; i < 3; i++){
    800058c2:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800058c4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800058c6:	00021c17          	auipc	s8,0x21
    800058ca:	73ac0c13          	addi	s8,s8,1850 # 80027000 <disk>
    800058ce:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800058d0:	4b0d                	li	s6,3
    800058d2:	a0ad                	j	8000593c <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800058d4:	00fc0733          	add	a4,s8,a5
    800058d8:	975e                	add	a4,a4,s7
    800058da:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800058de:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800058e0:	0207c563          	bltz	a5,8000590a <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800058e4:	2905                	addiw	s2,s2,1
    800058e6:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800058e8:	19690c63          	beq	s2,s6,80005a80 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    800058ec:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800058ee:	00023717          	auipc	a4,0x23
    800058f2:	72a70713          	addi	a4,a4,1834 # 80029018 <disk+0x2018>
    800058f6:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800058f8:	00074683          	lbu	a3,0(a4)
    800058fc:	fee1                	bnez	a3,800058d4 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800058fe:	2785                	addiw	a5,a5,1
    80005900:	0705                	addi	a4,a4,1
    80005902:	fe979be3          	bne	a5,s1,800058f8 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005906:	57fd                	li	a5,-1
    80005908:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000590a:	01205d63          	blez	s2,80005924 <virtio_disk_rw+0xa2>
    8000590e:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005910:	000a2503          	lw	a0,0(s4)
    80005914:	00000097          	auipc	ra,0x0
    80005918:	d92080e7          	jalr	-622(ra) # 800056a6 <free_desc>
      for(int j = 0; j < i; j++)
    8000591c:	2d85                	addiw	s11,s11,1
    8000591e:	0a11                	addi	s4,s4,4
    80005920:	ff2d98e3          	bne	s11,s2,80005910 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005924:	00024597          	auipc	a1,0x24
    80005928:	80458593          	addi	a1,a1,-2044 # 80029128 <disk+0x2128>
    8000592c:	00023517          	auipc	a0,0x23
    80005930:	6ec50513          	addi	a0,a0,1772 # 80029018 <disk+0x2018>
    80005934:	ffffc097          	auipc	ra,0xffffc
    80005938:	c6a080e7          	jalr	-918(ra) # 8000159e <sleep>
  for(int i = 0; i < 3; i++){
    8000593c:	f8040a13          	addi	s4,s0,-128
{
    80005940:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005942:	894e                	mv	s2,s3
    80005944:	b765                	j	800058ec <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005946:	00023697          	auipc	a3,0x23
    8000594a:	6ba6b683          	ld	a3,1722(a3) # 80029000 <disk+0x2000>
    8000594e:	96ba                	add	a3,a3,a4
    80005950:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005954:	00021817          	auipc	a6,0x21
    80005958:	6ac80813          	addi	a6,a6,1708 # 80027000 <disk>
    8000595c:	00023697          	auipc	a3,0x23
    80005960:	6a468693          	addi	a3,a3,1700 # 80029000 <disk+0x2000>
    80005964:	6290                	ld	a2,0(a3)
    80005966:	963a                	add	a2,a2,a4
    80005968:	00c65583          	lhu	a1,12(a2)
    8000596c:	0015e593          	ori	a1,a1,1
    80005970:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005974:	f8842603          	lw	a2,-120(s0)
    80005978:	628c                	ld	a1,0(a3)
    8000597a:	972e                	add	a4,a4,a1
    8000597c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005980:	20050593          	addi	a1,a0,512
    80005984:	0592                	slli	a1,a1,0x4
    80005986:	95c2                	add	a1,a1,a6
    80005988:	577d                	li	a4,-1
    8000598a:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000598e:	00461713          	slli	a4,a2,0x4
    80005992:	6290                	ld	a2,0(a3)
    80005994:	963a                	add	a2,a2,a4
    80005996:	03078793          	addi	a5,a5,48
    8000599a:	97c2                	add	a5,a5,a6
    8000599c:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    8000599e:	629c                	ld	a5,0(a3)
    800059a0:	97ba                	add	a5,a5,a4
    800059a2:	4605                	li	a2,1
    800059a4:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800059a6:	629c                	ld	a5,0(a3)
    800059a8:	97ba                	add	a5,a5,a4
    800059aa:	4809                	li	a6,2
    800059ac:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800059b0:	629c                	ld	a5,0(a3)
    800059b2:	97ba                	add	a5,a5,a4
    800059b4:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800059b8:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800059bc:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800059c0:	6698                	ld	a4,8(a3)
    800059c2:	00275783          	lhu	a5,2(a4)
    800059c6:	8b9d                	andi	a5,a5,7
    800059c8:	0786                	slli	a5,a5,0x1
    800059ca:	973e                	add	a4,a4,a5
    800059cc:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    800059d0:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800059d4:	6698                	ld	a4,8(a3)
    800059d6:	00275783          	lhu	a5,2(a4)
    800059da:	2785                	addiw	a5,a5,1
    800059dc:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800059e0:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800059e4:	100017b7          	lui	a5,0x10001
    800059e8:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800059ec:	004aa783          	lw	a5,4(s5)
    800059f0:	02c79163          	bne	a5,a2,80005a12 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800059f4:	00023917          	auipc	s2,0x23
    800059f8:	73490913          	addi	s2,s2,1844 # 80029128 <disk+0x2128>
  while(b->disk == 1) {
    800059fc:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800059fe:	85ca                	mv	a1,s2
    80005a00:	8556                	mv	a0,s5
    80005a02:	ffffc097          	auipc	ra,0xffffc
    80005a06:	b9c080e7          	jalr	-1124(ra) # 8000159e <sleep>
  while(b->disk == 1) {
    80005a0a:	004aa783          	lw	a5,4(s5)
    80005a0e:	fe9788e3          	beq	a5,s1,800059fe <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005a12:	f8042903          	lw	s2,-128(s0)
    80005a16:	20090713          	addi	a4,s2,512
    80005a1a:	0712                	slli	a4,a4,0x4
    80005a1c:	00021797          	auipc	a5,0x21
    80005a20:	5e478793          	addi	a5,a5,1508 # 80027000 <disk>
    80005a24:	97ba                	add	a5,a5,a4
    80005a26:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005a2a:	00023997          	auipc	s3,0x23
    80005a2e:	5d698993          	addi	s3,s3,1494 # 80029000 <disk+0x2000>
    80005a32:	00491713          	slli	a4,s2,0x4
    80005a36:	0009b783          	ld	a5,0(s3)
    80005a3a:	97ba                	add	a5,a5,a4
    80005a3c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005a40:	854a                	mv	a0,s2
    80005a42:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005a46:	00000097          	auipc	ra,0x0
    80005a4a:	c60080e7          	jalr	-928(ra) # 800056a6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005a4e:	8885                	andi	s1,s1,1
    80005a50:	f0ed                	bnez	s1,80005a32 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005a52:	00023517          	auipc	a0,0x23
    80005a56:	6d650513          	addi	a0,a0,1750 # 80029128 <disk+0x2128>
    80005a5a:	00001097          	auipc	ra,0x1
    80005a5e:	c84080e7          	jalr	-892(ra) # 800066de <release>
}
    80005a62:	70e6                	ld	ra,120(sp)
    80005a64:	7446                	ld	s0,112(sp)
    80005a66:	74a6                	ld	s1,104(sp)
    80005a68:	7906                	ld	s2,96(sp)
    80005a6a:	69e6                	ld	s3,88(sp)
    80005a6c:	6a46                	ld	s4,80(sp)
    80005a6e:	6aa6                	ld	s5,72(sp)
    80005a70:	6b06                	ld	s6,64(sp)
    80005a72:	7be2                	ld	s7,56(sp)
    80005a74:	7c42                	ld	s8,48(sp)
    80005a76:	7ca2                	ld	s9,40(sp)
    80005a78:	7d02                	ld	s10,32(sp)
    80005a7a:	6de2                	ld	s11,24(sp)
    80005a7c:	6109                	addi	sp,sp,128
    80005a7e:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005a80:	f8042503          	lw	a0,-128(s0)
    80005a84:	20050793          	addi	a5,a0,512
    80005a88:	0792                	slli	a5,a5,0x4
  if(write)
    80005a8a:	00021817          	auipc	a6,0x21
    80005a8e:	57680813          	addi	a6,a6,1398 # 80027000 <disk>
    80005a92:	00f80733          	add	a4,a6,a5
    80005a96:	01a036b3          	snez	a3,s10
    80005a9a:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    80005a9e:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005aa2:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005aa6:	7679                	lui	a2,0xffffe
    80005aa8:	963e                	add	a2,a2,a5
    80005aaa:	00023697          	auipc	a3,0x23
    80005aae:	55668693          	addi	a3,a3,1366 # 80029000 <disk+0x2000>
    80005ab2:	6298                	ld	a4,0(a3)
    80005ab4:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005ab6:	0a878593          	addi	a1,a5,168
    80005aba:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005abc:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005abe:	6298                	ld	a4,0(a3)
    80005ac0:	9732                	add	a4,a4,a2
    80005ac2:	45c1                	li	a1,16
    80005ac4:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005ac6:	6298                	ld	a4,0(a3)
    80005ac8:	9732                	add	a4,a4,a2
    80005aca:	4585                	li	a1,1
    80005acc:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005ad0:	f8442703          	lw	a4,-124(s0)
    80005ad4:	628c                	ld	a1,0(a3)
    80005ad6:	962e                	add	a2,a2,a1
    80005ad8:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffcbdce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005adc:	0712                	slli	a4,a4,0x4
    80005ade:	6290                	ld	a2,0(a3)
    80005ae0:	963a                	add	a2,a2,a4
    80005ae2:	058a8593          	addi	a1,s5,88
    80005ae6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005ae8:	6294                	ld	a3,0(a3)
    80005aea:	96ba                	add	a3,a3,a4
    80005aec:	40000613          	li	a2,1024
    80005af0:	c690                	sw	a2,8(a3)
  if(write)
    80005af2:	e40d1ae3          	bnez	s10,80005946 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005af6:	00023697          	auipc	a3,0x23
    80005afa:	50a6b683          	ld	a3,1290(a3) # 80029000 <disk+0x2000>
    80005afe:	96ba                	add	a3,a3,a4
    80005b00:	4609                	li	a2,2
    80005b02:	00c69623          	sh	a2,12(a3)
    80005b06:	b5b9                	j	80005954 <virtio_disk_rw+0xd2>

0000000080005b08 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005b08:	1101                	addi	sp,sp,-32
    80005b0a:	ec06                	sd	ra,24(sp)
    80005b0c:	e822                	sd	s0,16(sp)
    80005b0e:	e426                	sd	s1,8(sp)
    80005b10:	e04a                	sd	s2,0(sp)
    80005b12:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005b14:	00023517          	auipc	a0,0x23
    80005b18:	61450513          	addi	a0,a0,1556 # 80029128 <disk+0x2128>
    80005b1c:	00001097          	auipc	ra,0x1
    80005b20:	b0e080e7          	jalr	-1266(ra) # 8000662a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005b24:	10001737          	lui	a4,0x10001
    80005b28:	533c                	lw	a5,96(a4)
    80005b2a:	8b8d                	andi	a5,a5,3
    80005b2c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005b2e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005b32:	00023797          	auipc	a5,0x23
    80005b36:	4ce78793          	addi	a5,a5,1230 # 80029000 <disk+0x2000>
    80005b3a:	6b94                	ld	a3,16(a5)
    80005b3c:	0207d703          	lhu	a4,32(a5)
    80005b40:	0026d783          	lhu	a5,2(a3)
    80005b44:	06f70163          	beq	a4,a5,80005ba6 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005b48:	00021917          	auipc	s2,0x21
    80005b4c:	4b890913          	addi	s2,s2,1208 # 80027000 <disk>
    80005b50:	00023497          	auipc	s1,0x23
    80005b54:	4b048493          	addi	s1,s1,1200 # 80029000 <disk+0x2000>
    __sync_synchronize();
    80005b58:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005b5c:	6898                	ld	a4,16(s1)
    80005b5e:	0204d783          	lhu	a5,32(s1)
    80005b62:	8b9d                	andi	a5,a5,7
    80005b64:	078e                	slli	a5,a5,0x3
    80005b66:	97ba                	add	a5,a5,a4
    80005b68:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005b6a:	20078713          	addi	a4,a5,512
    80005b6e:	0712                	slli	a4,a4,0x4
    80005b70:	974a                	add	a4,a4,s2
    80005b72:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005b76:	e731                	bnez	a4,80005bc2 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005b78:	20078793          	addi	a5,a5,512
    80005b7c:	0792                	slli	a5,a5,0x4
    80005b7e:	97ca                	add	a5,a5,s2
    80005b80:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005b82:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005b86:	ffffc097          	auipc	ra,0xffffc
    80005b8a:	baa080e7          	jalr	-1110(ra) # 80001730 <wakeup>

    disk.used_idx += 1;
    80005b8e:	0204d783          	lhu	a5,32(s1)
    80005b92:	2785                	addiw	a5,a5,1
    80005b94:	17c2                	slli	a5,a5,0x30
    80005b96:	93c1                	srli	a5,a5,0x30
    80005b98:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005b9c:	6898                	ld	a4,16(s1)
    80005b9e:	00275703          	lhu	a4,2(a4)
    80005ba2:	faf71be3          	bne	a4,a5,80005b58 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005ba6:	00023517          	auipc	a0,0x23
    80005baa:	58250513          	addi	a0,a0,1410 # 80029128 <disk+0x2128>
    80005bae:	00001097          	auipc	ra,0x1
    80005bb2:	b30080e7          	jalr	-1232(ra) # 800066de <release>
}
    80005bb6:	60e2                	ld	ra,24(sp)
    80005bb8:	6442                	ld	s0,16(sp)
    80005bba:	64a2                	ld	s1,8(sp)
    80005bbc:	6902                	ld	s2,0(sp)
    80005bbe:	6105                	addi	sp,sp,32
    80005bc0:	8082                	ret
      panic("virtio_disk_intr status");
    80005bc2:	00003517          	auipc	a0,0x3
    80005bc6:	c1e50513          	addi	a0,a0,-994 # 800087e0 <syscalls+0x400>
    80005bca:	00000097          	auipc	ra,0x0
    80005bce:	528080e7          	jalr	1320(ra) # 800060f2 <panic>

0000000080005bd2 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005bd2:	1141                	addi	sp,sp,-16
    80005bd4:	e422                	sd	s0,8(sp)
    80005bd6:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005bd8:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005bdc:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005be0:	0037979b          	slliw	a5,a5,0x3
    80005be4:	02004737          	lui	a4,0x2004
    80005be8:	97ba                	add	a5,a5,a4
    80005bea:	0200c737          	lui	a4,0x200c
    80005bee:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005bf2:	000f4637          	lui	a2,0xf4
    80005bf6:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005bfa:	9732                	add	a4,a4,a2
    80005bfc:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005bfe:	00259693          	slli	a3,a1,0x2
    80005c02:	96ae                	add	a3,a3,a1
    80005c04:	068e                	slli	a3,a3,0x3
    80005c06:	00024717          	auipc	a4,0x24
    80005c0a:	3fa70713          	addi	a4,a4,1018 # 8002a000 <timer_scratch>
    80005c0e:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005c10:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005c12:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005c14:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005c18:	00000797          	auipc	a5,0x0
    80005c1c:	9c878793          	addi	a5,a5,-1592 # 800055e0 <timervec>
    80005c20:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005c24:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005c28:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005c2c:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005c30:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005c34:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005c38:	30479073          	csrw	mie,a5
}
    80005c3c:	6422                	ld	s0,8(sp)
    80005c3e:	0141                	addi	sp,sp,16
    80005c40:	8082                	ret

0000000080005c42 <start>:
{
    80005c42:	1141                	addi	sp,sp,-16
    80005c44:	e406                	sd	ra,8(sp)
    80005c46:	e022                	sd	s0,0(sp)
    80005c48:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005c4a:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005c4e:	7779                	lui	a4,0xffffe
    80005c50:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffcc5bf>
    80005c54:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005c56:	6705                	lui	a4,0x1
    80005c58:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005c5c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005c5e:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005c62:	ffffa797          	auipc	a5,0xffffa
    80005c66:	6be78793          	addi	a5,a5,1726 # 80000320 <main>
    80005c6a:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005c6e:	4781                	li	a5,0
    80005c70:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005c74:	67c1                	lui	a5,0x10
    80005c76:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005c78:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005c7c:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005c80:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005c84:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005c88:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005c8c:	57fd                	li	a5,-1
    80005c8e:	83a9                	srli	a5,a5,0xa
    80005c90:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005c94:	47bd                	li	a5,15
    80005c96:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005c9a:	00000097          	auipc	ra,0x0
    80005c9e:	f38080e7          	jalr	-200(ra) # 80005bd2 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005ca2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005ca6:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005ca8:	823e                	mv	tp,a5
  asm volatile("mret");
    80005caa:	30200073          	mret
}
    80005cae:	60a2                	ld	ra,8(sp)
    80005cb0:	6402                	ld	s0,0(sp)
    80005cb2:	0141                	addi	sp,sp,16
    80005cb4:	8082                	ret

0000000080005cb6 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005cb6:	715d                	addi	sp,sp,-80
    80005cb8:	e486                	sd	ra,72(sp)
    80005cba:	e0a2                	sd	s0,64(sp)
    80005cbc:	fc26                	sd	s1,56(sp)
    80005cbe:	f84a                	sd	s2,48(sp)
    80005cc0:	f44e                	sd	s3,40(sp)
    80005cc2:	f052                	sd	s4,32(sp)
    80005cc4:	ec56                	sd	s5,24(sp)
    80005cc6:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005cc8:	04c05763          	blez	a2,80005d16 <consolewrite+0x60>
    80005ccc:	8a2a                	mv	s4,a0
    80005cce:	84ae                	mv	s1,a1
    80005cd0:	89b2                	mv	s3,a2
    80005cd2:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005cd4:	5afd                	li	s5,-1
    80005cd6:	4685                	li	a3,1
    80005cd8:	8626                	mv	a2,s1
    80005cda:	85d2                	mv	a1,s4
    80005cdc:	fbf40513          	addi	a0,s0,-65
    80005ce0:	ffffc097          	auipc	ra,0xffffc
    80005ce4:	d6c080e7          	jalr	-660(ra) # 80001a4c <either_copyin>
    80005ce8:	01550d63          	beq	a0,s5,80005d02 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005cec:	fbf44503          	lbu	a0,-65(s0)
    80005cf0:	00000097          	auipc	ra,0x0
    80005cf4:	780080e7          	jalr	1920(ra) # 80006470 <uartputc>
  for(i = 0; i < n; i++){
    80005cf8:	2905                	addiw	s2,s2,1
    80005cfa:	0485                	addi	s1,s1,1
    80005cfc:	fd299de3          	bne	s3,s2,80005cd6 <consolewrite+0x20>
    80005d00:	894e                	mv	s2,s3
  }

  return i;
}
    80005d02:	854a                	mv	a0,s2
    80005d04:	60a6                	ld	ra,72(sp)
    80005d06:	6406                	ld	s0,64(sp)
    80005d08:	74e2                	ld	s1,56(sp)
    80005d0a:	7942                	ld	s2,48(sp)
    80005d0c:	79a2                	ld	s3,40(sp)
    80005d0e:	7a02                	ld	s4,32(sp)
    80005d10:	6ae2                	ld	s5,24(sp)
    80005d12:	6161                	addi	sp,sp,80
    80005d14:	8082                	ret
  for(i = 0; i < n; i++){
    80005d16:	4901                	li	s2,0
    80005d18:	b7ed                	j	80005d02 <consolewrite+0x4c>

0000000080005d1a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005d1a:	7159                	addi	sp,sp,-112
    80005d1c:	f486                	sd	ra,104(sp)
    80005d1e:	f0a2                	sd	s0,96(sp)
    80005d20:	eca6                	sd	s1,88(sp)
    80005d22:	e8ca                	sd	s2,80(sp)
    80005d24:	e4ce                	sd	s3,72(sp)
    80005d26:	e0d2                	sd	s4,64(sp)
    80005d28:	fc56                	sd	s5,56(sp)
    80005d2a:	f85a                	sd	s6,48(sp)
    80005d2c:	f45e                	sd	s7,40(sp)
    80005d2e:	f062                	sd	s8,32(sp)
    80005d30:	ec66                	sd	s9,24(sp)
    80005d32:	e86a                	sd	s10,16(sp)
    80005d34:	1880                	addi	s0,sp,112
    80005d36:	8aaa                	mv	s5,a0
    80005d38:	8a2e                	mv	s4,a1
    80005d3a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005d3c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005d40:	0002c517          	auipc	a0,0x2c
    80005d44:	40050513          	addi	a0,a0,1024 # 80032140 <cons>
    80005d48:	00001097          	auipc	ra,0x1
    80005d4c:	8e2080e7          	jalr	-1822(ra) # 8000662a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005d50:	0002c497          	auipc	s1,0x2c
    80005d54:	3f048493          	addi	s1,s1,1008 # 80032140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005d58:	0002c917          	auipc	s2,0x2c
    80005d5c:	48090913          	addi	s2,s2,1152 # 800321d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005d60:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005d62:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005d64:	4ca9                	li	s9,10
  while(n > 0){
    80005d66:	07305963          	blez	s3,80005dd8 <consoleread+0xbe>
    while(cons.r == cons.w){
    80005d6a:	0984a783          	lw	a5,152(s1)
    80005d6e:	09c4a703          	lw	a4,156(s1)
    80005d72:	02f71563          	bne	a4,a5,80005d9c <consoleread+0x82>
      if(myproc()->killed){
    80005d76:	ffffb097          	auipc	ra,0xffffb
    80005d7a:	0d0080e7          	jalr	208(ra) # 80000e46 <myproc>
    80005d7e:	33052783          	lw	a5,816(a0)
    80005d82:	e7b5                	bnez	a5,80005dee <consoleread+0xd4>
      sleep(&cons.r, &cons.lock);
    80005d84:	85a6                	mv	a1,s1
    80005d86:	854a                	mv	a0,s2
    80005d88:	ffffc097          	auipc	ra,0xffffc
    80005d8c:	816080e7          	jalr	-2026(ra) # 8000159e <sleep>
    while(cons.r == cons.w){
    80005d90:	0984a783          	lw	a5,152(s1)
    80005d94:	09c4a703          	lw	a4,156(s1)
    80005d98:	fcf70fe3          	beq	a4,a5,80005d76 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005d9c:	0017871b          	addiw	a4,a5,1
    80005da0:	08e4ac23          	sw	a4,152(s1)
    80005da4:	07f7f713          	andi	a4,a5,127
    80005da8:	9726                	add	a4,a4,s1
    80005daa:	01874703          	lbu	a4,24(a4)
    80005dae:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005db2:	077d0563          	beq	s10,s7,80005e1c <consoleread+0x102>
    cbuf = c;
    80005db6:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005dba:	4685                	li	a3,1
    80005dbc:	f9f40613          	addi	a2,s0,-97
    80005dc0:	85d2                	mv	a1,s4
    80005dc2:	8556                	mv	a0,s5
    80005dc4:	ffffc097          	auipc	ra,0xffffc
    80005dc8:	c30080e7          	jalr	-976(ra) # 800019f4 <either_copyout>
    80005dcc:	01850663          	beq	a0,s8,80005dd8 <consoleread+0xbe>
    dst++;
    80005dd0:	0a05                	addi	s4,s4,1
    --n;
    80005dd2:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005dd4:	f99d19e3          	bne	s10,s9,80005d66 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005dd8:	0002c517          	auipc	a0,0x2c
    80005ddc:	36850513          	addi	a0,a0,872 # 80032140 <cons>
    80005de0:	00001097          	auipc	ra,0x1
    80005de4:	8fe080e7          	jalr	-1794(ra) # 800066de <release>

  return target - n;
    80005de8:	413b053b          	subw	a0,s6,s3
    80005dec:	a811                	j	80005e00 <consoleread+0xe6>
        release(&cons.lock);
    80005dee:	0002c517          	auipc	a0,0x2c
    80005df2:	35250513          	addi	a0,a0,850 # 80032140 <cons>
    80005df6:	00001097          	auipc	ra,0x1
    80005dfa:	8e8080e7          	jalr	-1816(ra) # 800066de <release>
        return -1;
    80005dfe:	557d                	li	a0,-1
}
    80005e00:	70a6                	ld	ra,104(sp)
    80005e02:	7406                	ld	s0,96(sp)
    80005e04:	64e6                	ld	s1,88(sp)
    80005e06:	6946                	ld	s2,80(sp)
    80005e08:	69a6                	ld	s3,72(sp)
    80005e0a:	6a06                	ld	s4,64(sp)
    80005e0c:	7ae2                	ld	s5,56(sp)
    80005e0e:	7b42                	ld	s6,48(sp)
    80005e10:	7ba2                	ld	s7,40(sp)
    80005e12:	7c02                	ld	s8,32(sp)
    80005e14:	6ce2                	ld	s9,24(sp)
    80005e16:	6d42                	ld	s10,16(sp)
    80005e18:	6165                	addi	sp,sp,112
    80005e1a:	8082                	ret
      if(n < target){
    80005e1c:	0009871b          	sext.w	a4,s3
    80005e20:	fb677ce3          	bgeu	a4,s6,80005dd8 <consoleread+0xbe>
        cons.r--;
    80005e24:	0002c717          	auipc	a4,0x2c
    80005e28:	3af72a23          	sw	a5,948(a4) # 800321d8 <cons+0x98>
    80005e2c:	b775                	j	80005dd8 <consoleread+0xbe>

0000000080005e2e <consputc>:
{
    80005e2e:	1141                	addi	sp,sp,-16
    80005e30:	e406                	sd	ra,8(sp)
    80005e32:	e022                	sd	s0,0(sp)
    80005e34:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005e36:	10000793          	li	a5,256
    80005e3a:	00f50a63          	beq	a0,a5,80005e4e <consputc+0x20>
    uartputc_sync(c);
    80005e3e:	00000097          	auipc	ra,0x0
    80005e42:	560080e7          	jalr	1376(ra) # 8000639e <uartputc_sync>
}
    80005e46:	60a2                	ld	ra,8(sp)
    80005e48:	6402                	ld	s0,0(sp)
    80005e4a:	0141                	addi	sp,sp,16
    80005e4c:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005e4e:	4521                	li	a0,8
    80005e50:	00000097          	auipc	ra,0x0
    80005e54:	54e080e7          	jalr	1358(ra) # 8000639e <uartputc_sync>
    80005e58:	02000513          	li	a0,32
    80005e5c:	00000097          	auipc	ra,0x0
    80005e60:	542080e7          	jalr	1346(ra) # 8000639e <uartputc_sync>
    80005e64:	4521                	li	a0,8
    80005e66:	00000097          	auipc	ra,0x0
    80005e6a:	538080e7          	jalr	1336(ra) # 8000639e <uartputc_sync>
    80005e6e:	bfe1                	j	80005e46 <consputc+0x18>

0000000080005e70 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005e70:	1101                	addi	sp,sp,-32
    80005e72:	ec06                	sd	ra,24(sp)
    80005e74:	e822                	sd	s0,16(sp)
    80005e76:	e426                	sd	s1,8(sp)
    80005e78:	e04a                	sd	s2,0(sp)
    80005e7a:	1000                	addi	s0,sp,32
    80005e7c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005e7e:	0002c517          	auipc	a0,0x2c
    80005e82:	2c250513          	addi	a0,a0,706 # 80032140 <cons>
    80005e86:	00000097          	auipc	ra,0x0
    80005e8a:	7a4080e7          	jalr	1956(ra) # 8000662a <acquire>

  switch(c){
    80005e8e:	47d5                	li	a5,21
    80005e90:	0af48663          	beq	s1,a5,80005f3c <consoleintr+0xcc>
    80005e94:	0297ca63          	blt	a5,s1,80005ec8 <consoleintr+0x58>
    80005e98:	47a1                	li	a5,8
    80005e9a:	0ef48763          	beq	s1,a5,80005f88 <consoleintr+0x118>
    80005e9e:	47c1                	li	a5,16
    80005ea0:	10f49a63          	bne	s1,a5,80005fb4 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005ea4:	ffffc097          	auipc	ra,0xffffc
    80005ea8:	c00080e7          	jalr	-1024(ra) # 80001aa4 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005eac:	0002c517          	auipc	a0,0x2c
    80005eb0:	29450513          	addi	a0,a0,660 # 80032140 <cons>
    80005eb4:	00001097          	auipc	ra,0x1
    80005eb8:	82a080e7          	jalr	-2006(ra) # 800066de <release>
}
    80005ebc:	60e2                	ld	ra,24(sp)
    80005ebe:	6442                	ld	s0,16(sp)
    80005ec0:	64a2                	ld	s1,8(sp)
    80005ec2:	6902                	ld	s2,0(sp)
    80005ec4:	6105                	addi	sp,sp,32
    80005ec6:	8082                	ret
  switch(c){
    80005ec8:	07f00793          	li	a5,127
    80005ecc:	0af48e63          	beq	s1,a5,80005f88 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005ed0:	0002c717          	auipc	a4,0x2c
    80005ed4:	27070713          	addi	a4,a4,624 # 80032140 <cons>
    80005ed8:	0a072783          	lw	a5,160(a4)
    80005edc:	09872703          	lw	a4,152(a4)
    80005ee0:	9f99                	subw	a5,a5,a4
    80005ee2:	07f00713          	li	a4,127
    80005ee6:	fcf763e3          	bltu	a4,a5,80005eac <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005eea:	47b5                	li	a5,13
    80005eec:	0cf48763          	beq	s1,a5,80005fba <consoleintr+0x14a>
      consputc(c);
    80005ef0:	8526                	mv	a0,s1
    80005ef2:	00000097          	auipc	ra,0x0
    80005ef6:	f3c080e7          	jalr	-196(ra) # 80005e2e <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005efa:	0002c797          	auipc	a5,0x2c
    80005efe:	24678793          	addi	a5,a5,582 # 80032140 <cons>
    80005f02:	0a07a703          	lw	a4,160(a5)
    80005f06:	0017069b          	addiw	a3,a4,1
    80005f0a:	0006861b          	sext.w	a2,a3
    80005f0e:	0ad7a023          	sw	a3,160(a5)
    80005f12:	07f77713          	andi	a4,a4,127
    80005f16:	97ba                	add	a5,a5,a4
    80005f18:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005f1c:	47a9                	li	a5,10
    80005f1e:	0cf48563          	beq	s1,a5,80005fe8 <consoleintr+0x178>
    80005f22:	4791                	li	a5,4
    80005f24:	0cf48263          	beq	s1,a5,80005fe8 <consoleintr+0x178>
    80005f28:	0002c797          	auipc	a5,0x2c
    80005f2c:	2b07a783          	lw	a5,688(a5) # 800321d8 <cons+0x98>
    80005f30:	0807879b          	addiw	a5,a5,128
    80005f34:	f6f61ce3          	bne	a2,a5,80005eac <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005f38:	863e                	mv	a2,a5
    80005f3a:	a07d                	j	80005fe8 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005f3c:	0002c717          	auipc	a4,0x2c
    80005f40:	20470713          	addi	a4,a4,516 # 80032140 <cons>
    80005f44:	0a072783          	lw	a5,160(a4)
    80005f48:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005f4c:	0002c497          	auipc	s1,0x2c
    80005f50:	1f448493          	addi	s1,s1,500 # 80032140 <cons>
    while(cons.e != cons.w &&
    80005f54:	4929                	li	s2,10
    80005f56:	f4f70be3          	beq	a4,a5,80005eac <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005f5a:	37fd                	addiw	a5,a5,-1
    80005f5c:	07f7f713          	andi	a4,a5,127
    80005f60:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005f62:	01874703          	lbu	a4,24(a4)
    80005f66:	f52703e3          	beq	a4,s2,80005eac <consoleintr+0x3c>
      cons.e--;
    80005f6a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005f6e:	10000513          	li	a0,256
    80005f72:	00000097          	auipc	ra,0x0
    80005f76:	ebc080e7          	jalr	-324(ra) # 80005e2e <consputc>
    while(cons.e != cons.w &&
    80005f7a:	0a04a783          	lw	a5,160(s1)
    80005f7e:	09c4a703          	lw	a4,156(s1)
    80005f82:	fcf71ce3          	bne	a4,a5,80005f5a <consoleintr+0xea>
    80005f86:	b71d                	j	80005eac <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005f88:	0002c717          	auipc	a4,0x2c
    80005f8c:	1b870713          	addi	a4,a4,440 # 80032140 <cons>
    80005f90:	0a072783          	lw	a5,160(a4)
    80005f94:	09c72703          	lw	a4,156(a4)
    80005f98:	f0f70ae3          	beq	a4,a5,80005eac <consoleintr+0x3c>
      cons.e--;
    80005f9c:	37fd                	addiw	a5,a5,-1
    80005f9e:	0002c717          	auipc	a4,0x2c
    80005fa2:	24f72123          	sw	a5,578(a4) # 800321e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005fa6:	10000513          	li	a0,256
    80005faa:	00000097          	auipc	ra,0x0
    80005fae:	e84080e7          	jalr	-380(ra) # 80005e2e <consputc>
    80005fb2:	bded                	j	80005eac <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005fb4:	ee048ce3          	beqz	s1,80005eac <consoleintr+0x3c>
    80005fb8:	bf21                	j	80005ed0 <consoleintr+0x60>
      consputc(c);
    80005fba:	4529                	li	a0,10
    80005fbc:	00000097          	auipc	ra,0x0
    80005fc0:	e72080e7          	jalr	-398(ra) # 80005e2e <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005fc4:	0002c797          	auipc	a5,0x2c
    80005fc8:	17c78793          	addi	a5,a5,380 # 80032140 <cons>
    80005fcc:	0a07a703          	lw	a4,160(a5)
    80005fd0:	0017069b          	addiw	a3,a4,1
    80005fd4:	0006861b          	sext.w	a2,a3
    80005fd8:	0ad7a023          	sw	a3,160(a5)
    80005fdc:	07f77713          	andi	a4,a4,127
    80005fe0:	97ba                	add	a5,a5,a4
    80005fe2:	4729                	li	a4,10
    80005fe4:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005fe8:	0002c797          	auipc	a5,0x2c
    80005fec:	1ec7aa23          	sw	a2,500(a5) # 800321dc <cons+0x9c>
        wakeup(&cons.r);
    80005ff0:	0002c517          	auipc	a0,0x2c
    80005ff4:	1e850513          	addi	a0,a0,488 # 800321d8 <cons+0x98>
    80005ff8:	ffffb097          	auipc	ra,0xffffb
    80005ffc:	738080e7          	jalr	1848(ra) # 80001730 <wakeup>
    80006000:	b575                	j	80005eac <consoleintr+0x3c>

0000000080006002 <consoleinit>:

void
consoleinit(void)
{
    80006002:	1141                	addi	sp,sp,-16
    80006004:	e406                	sd	ra,8(sp)
    80006006:	e022                	sd	s0,0(sp)
    80006008:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000600a:	00002597          	auipc	a1,0x2
    8000600e:	7ee58593          	addi	a1,a1,2030 # 800087f8 <syscalls+0x418>
    80006012:	0002c517          	auipc	a0,0x2c
    80006016:	12e50513          	addi	a0,a0,302 # 80032140 <cons>
    8000601a:	00000097          	auipc	ra,0x0
    8000601e:	580080e7          	jalr	1408(ra) # 8000659a <initlock>

  uartinit();
    80006022:	00000097          	auipc	ra,0x0
    80006026:	32c080e7          	jalr	812(ra) # 8000634e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000602a:	0001f797          	auipc	a5,0x1f
    8000602e:	29e78793          	addi	a5,a5,670 # 800252c8 <devsw>
    80006032:	00000717          	auipc	a4,0x0
    80006036:	ce870713          	addi	a4,a4,-792 # 80005d1a <consoleread>
    8000603a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000603c:	00000717          	auipc	a4,0x0
    80006040:	c7a70713          	addi	a4,a4,-902 # 80005cb6 <consolewrite>
    80006044:	ef98                	sd	a4,24(a5)
}
    80006046:	60a2                	ld	ra,8(sp)
    80006048:	6402                	ld	s0,0(sp)
    8000604a:	0141                	addi	sp,sp,16
    8000604c:	8082                	ret

000000008000604e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000604e:	7179                	addi	sp,sp,-48
    80006050:	f406                	sd	ra,40(sp)
    80006052:	f022                	sd	s0,32(sp)
    80006054:	ec26                	sd	s1,24(sp)
    80006056:	e84a                	sd	s2,16(sp)
    80006058:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    8000605a:	c219                	beqz	a2,80006060 <printint+0x12>
    8000605c:	08054763          	bltz	a0,800060ea <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80006060:	2501                	sext.w	a0,a0
    80006062:	4881                	li	a7,0
    80006064:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006068:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    8000606a:	2581                	sext.w	a1,a1
    8000606c:	00002617          	auipc	a2,0x2
    80006070:	7bc60613          	addi	a2,a2,1980 # 80008828 <digits>
    80006074:	883a                	mv	a6,a4
    80006076:	2705                	addiw	a4,a4,1
    80006078:	02b577bb          	remuw	a5,a0,a1
    8000607c:	1782                	slli	a5,a5,0x20
    8000607e:	9381                	srli	a5,a5,0x20
    80006080:	97b2                	add	a5,a5,a2
    80006082:	0007c783          	lbu	a5,0(a5)
    80006086:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    8000608a:	0005079b          	sext.w	a5,a0
    8000608e:	02b5553b          	divuw	a0,a0,a1
    80006092:	0685                	addi	a3,a3,1
    80006094:	feb7f0e3          	bgeu	a5,a1,80006074 <printint+0x26>

  if(sign)
    80006098:	00088c63          	beqz	a7,800060b0 <printint+0x62>
    buf[i++] = '-';
    8000609c:	fe070793          	addi	a5,a4,-32
    800060a0:	00878733          	add	a4,a5,s0
    800060a4:	02d00793          	li	a5,45
    800060a8:	fef70823          	sb	a5,-16(a4)
    800060ac:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800060b0:	02e05763          	blez	a4,800060de <printint+0x90>
    800060b4:	fd040793          	addi	a5,s0,-48
    800060b8:	00e784b3          	add	s1,a5,a4
    800060bc:	fff78913          	addi	s2,a5,-1
    800060c0:	993a                	add	s2,s2,a4
    800060c2:	377d                	addiw	a4,a4,-1
    800060c4:	1702                	slli	a4,a4,0x20
    800060c6:	9301                	srli	a4,a4,0x20
    800060c8:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800060cc:	fff4c503          	lbu	a0,-1(s1)
    800060d0:	00000097          	auipc	ra,0x0
    800060d4:	d5e080e7          	jalr	-674(ra) # 80005e2e <consputc>
  while(--i >= 0)
    800060d8:	14fd                	addi	s1,s1,-1
    800060da:	ff2499e3          	bne	s1,s2,800060cc <printint+0x7e>
}
    800060de:	70a2                	ld	ra,40(sp)
    800060e0:	7402                	ld	s0,32(sp)
    800060e2:	64e2                	ld	s1,24(sp)
    800060e4:	6942                	ld	s2,16(sp)
    800060e6:	6145                	addi	sp,sp,48
    800060e8:	8082                	ret
    x = -xx;
    800060ea:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    800060ee:	4885                	li	a7,1
    x = -xx;
    800060f0:	bf95                	j	80006064 <printint+0x16>

00000000800060f2 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    800060f2:	1101                	addi	sp,sp,-32
    800060f4:	ec06                	sd	ra,24(sp)
    800060f6:	e822                	sd	s0,16(sp)
    800060f8:	e426                	sd	s1,8(sp)
    800060fa:	1000                	addi	s0,sp,32
    800060fc:	84aa                	mv	s1,a0
  pr.locking = 0;
    800060fe:	0002c797          	auipc	a5,0x2c
    80006102:	1007a123          	sw	zero,258(a5) # 80032200 <pr+0x18>
  printf("panic: ");
    80006106:	00002517          	auipc	a0,0x2
    8000610a:	6fa50513          	addi	a0,a0,1786 # 80008800 <syscalls+0x420>
    8000610e:	00000097          	auipc	ra,0x0
    80006112:	02e080e7          	jalr	46(ra) # 8000613c <printf>
  printf(s);
    80006116:	8526                	mv	a0,s1
    80006118:	00000097          	auipc	ra,0x0
    8000611c:	024080e7          	jalr	36(ra) # 8000613c <printf>
  printf("\n");
    80006120:	00002517          	auipc	a0,0x2
    80006124:	f2850513          	addi	a0,a0,-216 # 80008048 <etext+0x48>
    80006128:	00000097          	auipc	ra,0x0
    8000612c:	014080e7          	jalr	20(ra) # 8000613c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006130:	4785                	li	a5,1
    80006132:	00003717          	auipc	a4,0x3
    80006136:	eef72523          	sw	a5,-278(a4) # 8000901c <panicked>
  for(;;)
    8000613a:	a001                	j	8000613a <panic+0x48>

000000008000613c <printf>:
{
    8000613c:	7131                	addi	sp,sp,-192
    8000613e:	fc86                	sd	ra,120(sp)
    80006140:	f8a2                	sd	s0,112(sp)
    80006142:	f4a6                	sd	s1,104(sp)
    80006144:	f0ca                	sd	s2,96(sp)
    80006146:	ecce                	sd	s3,88(sp)
    80006148:	e8d2                	sd	s4,80(sp)
    8000614a:	e4d6                	sd	s5,72(sp)
    8000614c:	e0da                	sd	s6,64(sp)
    8000614e:	fc5e                	sd	s7,56(sp)
    80006150:	f862                	sd	s8,48(sp)
    80006152:	f466                	sd	s9,40(sp)
    80006154:	f06a                	sd	s10,32(sp)
    80006156:	ec6e                	sd	s11,24(sp)
    80006158:	0100                	addi	s0,sp,128
    8000615a:	8a2a                	mv	s4,a0
    8000615c:	e40c                	sd	a1,8(s0)
    8000615e:	e810                	sd	a2,16(s0)
    80006160:	ec14                	sd	a3,24(s0)
    80006162:	f018                	sd	a4,32(s0)
    80006164:	f41c                	sd	a5,40(s0)
    80006166:	03043823          	sd	a6,48(s0)
    8000616a:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    8000616e:	0002cd97          	auipc	s11,0x2c
    80006172:	092dad83          	lw	s11,146(s11) # 80032200 <pr+0x18>
  if(locking)
    80006176:	020d9b63          	bnez	s11,800061ac <printf+0x70>
  if (fmt == 0)
    8000617a:	040a0263          	beqz	s4,800061be <printf+0x82>
  va_start(ap, fmt);
    8000617e:	00840793          	addi	a5,s0,8
    80006182:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006186:	000a4503          	lbu	a0,0(s4)
    8000618a:	14050f63          	beqz	a0,800062e8 <printf+0x1ac>
    8000618e:	4981                	li	s3,0
    if(c != '%'){
    80006190:	02500a93          	li	s5,37
    switch(c){
    80006194:	07000b93          	li	s7,112
  consputc('x');
    80006198:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000619a:	00002b17          	auipc	s6,0x2
    8000619e:	68eb0b13          	addi	s6,s6,1678 # 80008828 <digits>
    switch(c){
    800061a2:	07300c93          	li	s9,115
    800061a6:	06400c13          	li	s8,100
    800061aa:	a82d                	j	800061e4 <printf+0xa8>
    acquire(&pr.lock);
    800061ac:	0002c517          	auipc	a0,0x2c
    800061b0:	03c50513          	addi	a0,a0,60 # 800321e8 <pr>
    800061b4:	00000097          	auipc	ra,0x0
    800061b8:	476080e7          	jalr	1142(ra) # 8000662a <acquire>
    800061bc:	bf7d                	j	8000617a <printf+0x3e>
    panic("null fmt");
    800061be:	00002517          	auipc	a0,0x2
    800061c2:	65250513          	addi	a0,a0,1618 # 80008810 <syscalls+0x430>
    800061c6:	00000097          	auipc	ra,0x0
    800061ca:	f2c080e7          	jalr	-212(ra) # 800060f2 <panic>
      consputc(c);
    800061ce:	00000097          	auipc	ra,0x0
    800061d2:	c60080e7          	jalr	-928(ra) # 80005e2e <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800061d6:	2985                	addiw	s3,s3,1
    800061d8:	013a07b3          	add	a5,s4,s3
    800061dc:	0007c503          	lbu	a0,0(a5)
    800061e0:	10050463          	beqz	a0,800062e8 <printf+0x1ac>
    if(c != '%'){
    800061e4:	ff5515e3          	bne	a0,s5,800061ce <printf+0x92>
    c = fmt[++i] & 0xff;
    800061e8:	2985                	addiw	s3,s3,1
    800061ea:	013a07b3          	add	a5,s4,s3
    800061ee:	0007c783          	lbu	a5,0(a5)
    800061f2:	0007849b          	sext.w	s1,a5
    if(c == 0)
    800061f6:	cbed                	beqz	a5,800062e8 <printf+0x1ac>
    switch(c){
    800061f8:	05778a63          	beq	a5,s7,8000624c <printf+0x110>
    800061fc:	02fbf663          	bgeu	s7,a5,80006228 <printf+0xec>
    80006200:	09978863          	beq	a5,s9,80006290 <printf+0x154>
    80006204:	07800713          	li	a4,120
    80006208:	0ce79563          	bne	a5,a4,800062d2 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    8000620c:	f8843783          	ld	a5,-120(s0)
    80006210:	00878713          	addi	a4,a5,8
    80006214:	f8e43423          	sd	a4,-120(s0)
    80006218:	4605                	li	a2,1
    8000621a:	85ea                	mv	a1,s10
    8000621c:	4388                	lw	a0,0(a5)
    8000621e:	00000097          	auipc	ra,0x0
    80006222:	e30080e7          	jalr	-464(ra) # 8000604e <printint>
      break;
    80006226:	bf45                	j	800061d6 <printf+0x9a>
    switch(c){
    80006228:	09578f63          	beq	a5,s5,800062c6 <printf+0x18a>
    8000622c:	0b879363          	bne	a5,s8,800062d2 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80006230:	f8843783          	ld	a5,-120(s0)
    80006234:	00878713          	addi	a4,a5,8
    80006238:	f8e43423          	sd	a4,-120(s0)
    8000623c:	4605                	li	a2,1
    8000623e:	45a9                	li	a1,10
    80006240:	4388                	lw	a0,0(a5)
    80006242:	00000097          	auipc	ra,0x0
    80006246:	e0c080e7          	jalr	-500(ra) # 8000604e <printint>
      break;
    8000624a:	b771                	j	800061d6 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000624c:	f8843783          	ld	a5,-120(s0)
    80006250:	00878713          	addi	a4,a5,8
    80006254:	f8e43423          	sd	a4,-120(s0)
    80006258:	0007b903          	ld	s2,0(a5)
  consputc('0');
    8000625c:	03000513          	li	a0,48
    80006260:	00000097          	auipc	ra,0x0
    80006264:	bce080e7          	jalr	-1074(ra) # 80005e2e <consputc>
  consputc('x');
    80006268:	07800513          	li	a0,120
    8000626c:	00000097          	auipc	ra,0x0
    80006270:	bc2080e7          	jalr	-1086(ra) # 80005e2e <consputc>
    80006274:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006276:	03c95793          	srli	a5,s2,0x3c
    8000627a:	97da                	add	a5,a5,s6
    8000627c:	0007c503          	lbu	a0,0(a5)
    80006280:	00000097          	auipc	ra,0x0
    80006284:	bae080e7          	jalr	-1106(ra) # 80005e2e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006288:	0912                	slli	s2,s2,0x4
    8000628a:	34fd                	addiw	s1,s1,-1
    8000628c:	f4ed                	bnez	s1,80006276 <printf+0x13a>
    8000628e:	b7a1                	j	800061d6 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006290:	f8843783          	ld	a5,-120(s0)
    80006294:	00878713          	addi	a4,a5,8
    80006298:	f8e43423          	sd	a4,-120(s0)
    8000629c:	6384                	ld	s1,0(a5)
    8000629e:	cc89                	beqz	s1,800062b8 <printf+0x17c>
      for(; *s; s++)
    800062a0:	0004c503          	lbu	a0,0(s1)
    800062a4:	d90d                	beqz	a0,800061d6 <printf+0x9a>
        consputc(*s);
    800062a6:	00000097          	auipc	ra,0x0
    800062aa:	b88080e7          	jalr	-1144(ra) # 80005e2e <consputc>
      for(; *s; s++)
    800062ae:	0485                	addi	s1,s1,1
    800062b0:	0004c503          	lbu	a0,0(s1)
    800062b4:	f96d                	bnez	a0,800062a6 <printf+0x16a>
    800062b6:	b705                	j	800061d6 <printf+0x9a>
        s = "(null)";
    800062b8:	00002497          	auipc	s1,0x2
    800062bc:	55048493          	addi	s1,s1,1360 # 80008808 <syscalls+0x428>
      for(; *s; s++)
    800062c0:	02800513          	li	a0,40
    800062c4:	b7cd                	j	800062a6 <printf+0x16a>
      consputc('%');
    800062c6:	8556                	mv	a0,s5
    800062c8:	00000097          	auipc	ra,0x0
    800062cc:	b66080e7          	jalr	-1178(ra) # 80005e2e <consputc>
      break;
    800062d0:	b719                	j	800061d6 <printf+0x9a>
      consputc('%');
    800062d2:	8556                	mv	a0,s5
    800062d4:	00000097          	auipc	ra,0x0
    800062d8:	b5a080e7          	jalr	-1190(ra) # 80005e2e <consputc>
      consputc(c);
    800062dc:	8526                	mv	a0,s1
    800062de:	00000097          	auipc	ra,0x0
    800062e2:	b50080e7          	jalr	-1200(ra) # 80005e2e <consputc>
      break;
    800062e6:	bdc5                	j	800061d6 <printf+0x9a>
  if(locking)
    800062e8:	020d9163          	bnez	s11,8000630a <printf+0x1ce>
}
    800062ec:	70e6                	ld	ra,120(sp)
    800062ee:	7446                	ld	s0,112(sp)
    800062f0:	74a6                	ld	s1,104(sp)
    800062f2:	7906                	ld	s2,96(sp)
    800062f4:	69e6                	ld	s3,88(sp)
    800062f6:	6a46                	ld	s4,80(sp)
    800062f8:	6aa6                	ld	s5,72(sp)
    800062fa:	6b06                	ld	s6,64(sp)
    800062fc:	7be2                	ld	s7,56(sp)
    800062fe:	7c42                	ld	s8,48(sp)
    80006300:	7ca2                	ld	s9,40(sp)
    80006302:	7d02                	ld	s10,32(sp)
    80006304:	6de2                	ld	s11,24(sp)
    80006306:	6129                	addi	sp,sp,192
    80006308:	8082                	ret
    release(&pr.lock);
    8000630a:	0002c517          	auipc	a0,0x2c
    8000630e:	ede50513          	addi	a0,a0,-290 # 800321e8 <pr>
    80006312:	00000097          	auipc	ra,0x0
    80006316:	3cc080e7          	jalr	972(ra) # 800066de <release>
}
    8000631a:	bfc9                	j	800062ec <printf+0x1b0>

000000008000631c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000631c:	1101                	addi	sp,sp,-32
    8000631e:	ec06                	sd	ra,24(sp)
    80006320:	e822                	sd	s0,16(sp)
    80006322:	e426                	sd	s1,8(sp)
    80006324:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006326:	0002c497          	auipc	s1,0x2c
    8000632a:	ec248493          	addi	s1,s1,-318 # 800321e8 <pr>
    8000632e:	00002597          	auipc	a1,0x2
    80006332:	4f258593          	addi	a1,a1,1266 # 80008820 <syscalls+0x440>
    80006336:	8526                	mv	a0,s1
    80006338:	00000097          	auipc	ra,0x0
    8000633c:	262080e7          	jalr	610(ra) # 8000659a <initlock>
  pr.locking = 1;
    80006340:	4785                	li	a5,1
    80006342:	cc9c                	sw	a5,24(s1)
}
    80006344:	60e2                	ld	ra,24(sp)
    80006346:	6442                	ld	s0,16(sp)
    80006348:	64a2                	ld	s1,8(sp)
    8000634a:	6105                	addi	sp,sp,32
    8000634c:	8082                	ret

000000008000634e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000634e:	1141                	addi	sp,sp,-16
    80006350:	e406                	sd	ra,8(sp)
    80006352:	e022                	sd	s0,0(sp)
    80006354:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006356:	100007b7          	lui	a5,0x10000
    8000635a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000635e:	f8000713          	li	a4,-128
    80006362:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006366:	470d                	li	a4,3
    80006368:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000636c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006370:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006374:	469d                	li	a3,7
    80006376:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000637a:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000637e:	00002597          	auipc	a1,0x2
    80006382:	4c258593          	addi	a1,a1,1218 # 80008840 <digits+0x18>
    80006386:	0002c517          	auipc	a0,0x2c
    8000638a:	e8250513          	addi	a0,a0,-382 # 80032208 <uart_tx_lock>
    8000638e:	00000097          	auipc	ra,0x0
    80006392:	20c080e7          	jalr	524(ra) # 8000659a <initlock>
}
    80006396:	60a2                	ld	ra,8(sp)
    80006398:	6402                	ld	s0,0(sp)
    8000639a:	0141                	addi	sp,sp,16
    8000639c:	8082                	ret

000000008000639e <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000639e:	1101                	addi	sp,sp,-32
    800063a0:	ec06                	sd	ra,24(sp)
    800063a2:	e822                	sd	s0,16(sp)
    800063a4:	e426                	sd	s1,8(sp)
    800063a6:	1000                	addi	s0,sp,32
    800063a8:	84aa                	mv	s1,a0
  push_off();
    800063aa:	00000097          	auipc	ra,0x0
    800063ae:	234080e7          	jalr	564(ra) # 800065de <push_off>

  if(panicked){
    800063b2:	00003797          	auipc	a5,0x3
    800063b6:	c6a7a783          	lw	a5,-918(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800063ba:	10000737          	lui	a4,0x10000
  if(panicked){
    800063be:	c391                	beqz	a5,800063c2 <uartputc_sync+0x24>
    for(;;)
    800063c0:	a001                	j	800063c0 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800063c2:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800063c6:	0207f793          	andi	a5,a5,32
    800063ca:	dfe5                	beqz	a5,800063c2 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800063cc:	0ff4f513          	zext.b	a0,s1
    800063d0:	100007b7          	lui	a5,0x10000
    800063d4:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800063d8:	00000097          	auipc	ra,0x0
    800063dc:	2a6080e7          	jalr	678(ra) # 8000667e <pop_off>
}
    800063e0:	60e2                	ld	ra,24(sp)
    800063e2:	6442                	ld	s0,16(sp)
    800063e4:	64a2                	ld	s1,8(sp)
    800063e6:	6105                	addi	sp,sp,32
    800063e8:	8082                	ret

00000000800063ea <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800063ea:	00003797          	auipc	a5,0x3
    800063ee:	c367b783          	ld	a5,-970(a5) # 80009020 <uart_tx_r>
    800063f2:	00003717          	auipc	a4,0x3
    800063f6:	c3673703          	ld	a4,-970(a4) # 80009028 <uart_tx_w>
    800063fa:	06f70a63          	beq	a4,a5,8000646e <uartstart+0x84>
{
    800063fe:	7139                	addi	sp,sp,-64
    80006400:	fc06                	sd	ra,56(sp)
    80006402:	f822                	sd	s0,48(sp)
    80006404:	f426                	sd	s1,40(sp)
    80006406:	f04a                	sd	s2,32(sp)
    80006408:	ec4e                	sd	s3,24(sp)
    8000640a:	e852                	sd	s4,16(sp)
    8000640c:	e456                	sd	s5,8(sp)
    8000640e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006410:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006414:	0002ca17          	auipc	s4,0x2c
    80006418:	df4a0a13          	addi	s4,s4,-524 # 80032208 <uart_tx_lock>
    uart_tx_r += 1;
    8000641c:	00003497          	auipc	s1,0x3
    80006420:	c0448493          	addi	s1,s1,-1020 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006424:	00003997          	auipc	s3,0x3
    80006428:	c0498993          	addi	s3,s3,-1020 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000642c:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006430:	02077713          	andi	a4,a4,32
    80006434:	c705                	beqz	a4,8000645c <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006436:	01f7f713          	andi	a4,a5,31
    8000643a:	9752                	add	a4,a4,s4
    8000643c:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80006440:	0785                	addi	a5,a5,1
    80006442:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006444:	8526                	mv	a0,s1
    80006446:	ffffb097          	auipc	ra,0xffffb
    8000644a:	2ea080e7          	jalr	746(ra) # 80001730 <wakeup>
    
    WriteReg(THR, c);
    8000644e:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006452:	609c                	ld	a5,0(s1)
    80006454:	0009b703          	ld	a4,0(s3)
    80006458:	fcf71ae3          	bne	a4,a5,8000642c <uartstart+0x42>
  }
}
    8000645c:	70e2                	ld	ra,56(sp)
    8000645e:	7442                	ld	s0,48(sp)
    80006460:	74a2                	ld	s1,40(sp)
    80006462:	7902                	ld	s2,32(sp)
    80006464:	69e2                	ld	s3,24(sp)
    80006466:	6a42                	ld	s4,16(sp)
    80006468:	6aa2                	ld	s5,8(sp)
    8000646a:	6121                	addi	sp,sp,64
    8000646c:	8082                	ret
    8000646e:	8082                	ret

0000000080006470 <uartputc>:
{
    80006470:	7179                	addi	sp,sp,-48
    80006472:	f406                	sd	ra,40(sp)
    80006474:	f022                	sd	s0,32(sp)
    80006476:	ec26                	sd	s1,24(sp)
    80006478:	e84a                	sd	s2,16(sp)
    8000647a:	e44e                	sd	s3,8(sp)
    8000647c:	e052                	sd	s4,0(sp)
    8000647e:	1800                	addi	s0,sp,48
    80006480:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006482:	0002c517          	auipc	a0,0x2c
    80006486:	d8650513          	addi	a0,a0,-634 # 80032208 <uart_tx_lock>
    8000648a:	00000097          	auipc	ra,0x0
    8000648e:	1a0080e7          	jalr	416(ra) # 8000662a <acquire>
  if(panicked){
    80006492:	00003797          	auipc	a5,0x3
    80006496:	b8a7a783          	lw	a5,-1142(a5) # 8000901c <panicked>
    8000649a:	c391                	beqz	a5,8000649e <uartputc+0x2e>
    for(;;)
    8000649c:	a001                	j	8000649c <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000649e:	00003717          	auipc	a4,0x3
    800064a2:	b8a73703          	ld	a4,-1142(a4) # 80009028 <uart_tx_w>
    800064a6:	00003797          	auipc	a5,0x3
    800064aa:	b7a7b783          	ld	a5,-1158(a5) # 80009020 <uart_tx_r>
    800064ae:	02078793          	addi	a5,a5,32
    800064b2:	02e79b63          	bne	a5,a4,800064e8 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800064b6:	0002c997          	auipc	s3,0x2c
    800064ba:	d5298993          	addi	s3,s3,-686 # 80032208 <uart_tx_lock>
    800064be:	00003497          	auipc	s1,0x3
    800064c2:	b6248493          	addi	s1,s1,-1182 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800064c6:	00003917          	auipc	s2,0x3
    800064ca:	b6290913          	addi	s2,s2,-1182 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800064ce:	85ce                	mv	a1,s3
    800064d0:	8526                	mv	a0,s1
    800064d2:	ffffb097          	auipc	ra,0xffffb
    800064d6:	0cc080e7          	jalr	204(ra) # 8000159e <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800064da:	00093703          	ld	a4,0(s2)
    800064de:	609c                	ld	a5,0(s1)
    800064e0:	02078793          	addi	a5,a5,32
    800064e4:	fee785e3          	beq	a5,a4,800064ce <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800064e8:	0002c497          	auipc	s1,0x2c
    800064ec:	d2048493          	addi	s1,s1,-736 # 80032208 <uart_tx_lock>
    800064f0:	01f77793          	andi	a5,a4,31
    800064f4:	97a6                	add	a5,a5,s1
    800064f6:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800064fa:	0705                	addi	a4,a4,1
    800064fc:	00003797          	auipc	a5,0x3
    80006500:	b2e7b623          	sd	a4,-1236(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006504:	00000097          	auipc	ra,0x0
    80006508:	ee6080e7          	jalr	-282(ra) # 800063ea <uartstart>
      release(&uart_tx_lock);
    8000650c:	8526                	mv	a0,s1
    8000650e:	00000097          	auipc	ra,0x0
    80006512:	1d0080e7          	jalr	464(ra) # 800066de <release>
}
    80006516:	70a2                	ld	ra,40(sp)
    80006518:	7402                	ld	s0,32(sp)
    8000651a:	64e2                	ld	s1,24(sp)
    8000651c:	6942                	ld	s2,16(sp)
    8000651e:	69a2                	ld	s3,8(sp)
    80006520:	6a02                	ld	s4,0(sp)
    80006522:	6145                	addi	sp,sp,48
    80006524:	8082                	ret

0000000080006526 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006526:	1141                	addi	sp,sp,-16
    80006528:	e422                	sd	s0,8(sp)
    8000652a:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000652c:	100007b7          	lui	a5,0x10000
    80006530:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006534:	8b85                	andi	a5,a5,1
    80006536:	cb81                	beqz	a5,80006546 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006538:	100007b7          	lui	a5,0x10000
    8000653c:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006540:	6422                	ld	s0,8(sp)
    80006542:	0141                	addi	sp,sp,16
    80006544:	8082                	ret
    return -1;
    80006546:	557d                	li	a0,-1
    80006548:	bfe5                	j	80006540 <uartgetc+0x1a>

000000008000654a <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    8000654a:	1101                	addi	sp,sp,-32
    8000654c:	ec06                	sd	ra,24(sp)
    8000654e:	e822                	sd	s0,16(sp)
    80006550:	e426                	sd	s1,8(sp)
    80006552:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006554:	54fd                	li	s1,-1
    80006556:	a029                	j	80006560 <uartintr+0x16>
      break;
    consoleintr(c);
    80006558:	00000097          	auipc	ra,0x0
    8000655c:	918080e7          	jalr	-1768(ra) # 80005e70 <consoleintr>
    int c = uartgetc();
    80006560:	00000097          	auipc	ra,0x0
    80006564:	fc6080e7          	jalr	-58(ra) # 80006526 <uartgetc>
    if(c == -1)
    80006568:	fe9518e3          	bne	a0,s1,80006558 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000656c:	0002c497          	auipc	s1,0x2c
    80006570:	c9c48493          	addi	s1,s1,-868 # 80032208 <uart_tx_lock>
    80006574:	8526                	mv	a0,s1
    80006576:	00000097          	auipc	ra,0x0
    8000657a:	0b4080e7          	jalr	180(ra) # 8000662a <acquire>
  uartstart();
    8000657e:	00000097          	auipc	ra,0x0
    80006582:	e6c080e7          	jalr	-404(ra) # 800063ea <uartstart>
  release(&uart_tx_lock);
    80006586:	8526                	mv	a0,s1
    80006588:	00000097          	auipc	ra,0x0
    8000658c:	156080e7          	jalr	342(ra) # 800066de <release>
}
    80006590:	60e2                	ld	ra,24(sp)
    80006592:	6442                	ld	s0,16(sp)
    80006594:	64a2                	ld	s1,8(sp)
    80006596:	6105                	addi	sp,sp,32
    80006598:	8082                	ret

000000008000659a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000659a:	1141                	addi	sp,sp,-16
    8000659c:	e422                	sd	s0,8(sp)
    8000659e:	0800                	addi	s0,sp,16
  lk->name = name;
    800065a0:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800065a2:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800065a6:	00053823          	sd	zero,16(a0)
}
    800065aa:	6422                	ld	s0,8(sp)
    800065ac:	0141                	addi	sp,sp,16
    800065ae:	8082                	ret

00000000800065b0 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800065b0:	411c                	lw	a5,0(a0)
    800065b2:	e399                	bnez	a5,800065b8 <holding+0x8>
    800065b4:	4501                	li	a0,0
  return r;
}
    800065b6:	8082                	ret
{
    800065b8:	1101                	addi	sp,sp,-32
    800065ba:	ec06                	sd	ra,24(sp)
    800065bc:	e822                	sd	s0,16(sp)
    800065be:	e426                	sd	s1,8(sp)
    800065c0:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800065c2:	6904                	ld	s1,16(a0)
    800065c4:	ffffb097          	auipc	ra,0xffffb
    800065c8:	866080e7          	jalr	-1946(ra) # 80000e2a <mycpu>
    800065cc:	40a48533          	sub	a0,s1,a0
    800065d0:	00153513          	seqz	a0,a0
}
    800065d4:	60e2                	ld	ra,24(sp)
    800065d6:	6442                	ld	s0,16(sp)
    800065d8:	64a2                	ld	s1,8(sp)
    800065da:	6105                	addi	sp,sp,32
    800065dc:	8082                	ret

00000000800065de <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800065de:	1101                	addi	sp,sp,-32
    800065e0:	ec06                	sd	ra,24(sp)
    800065e2:	e822                	sd	s0,16(sp)
    800065e4:	e426                	sd	s1,8(sp)
    800065e6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800065e8:	100024f3          	csrr	s1,sstatus
    800065ec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800065f0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800065f2:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800065f6:	ffffb097          	auipc	ra,0xffffb
    800065fa:	834080e7          	jalr	-1996(ra) # 80000e2a <mycpu>
    800065fe:	5d3c                	lw	a5,120(a0)
    80006600:	cf89                	beqz	a5,8000661a <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006602:	ffffb097          	auipc	ra,0xffffb
    80006606:	828080e7          	jalr	-2008(ra) # 80000e2a <mycpu>
    8000660a:	5d3c                	lw	a5,120(a0)
    8000660c:	2785                	addiw	a5,a5,1
    8000660e:	dd3c                	sw	a5,120(a0)
}
    80006610:	60e2                	ld	ra,24(sp)
    80006612:	6442                	ld	s0,16(sp)
    80006614:	64a2                	ld	s1,8(sp)
    80006616:	6105                	addi	sp,sp,32
    80006618:	8082                	ret
    mycpu()->intena = old;
    8000661a:	ffffb097          	auipc	ra,0xffffb
    8000661e:	810080e7          	jalr	-2032(ra) # 80000e2a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006622:	8085                	srli	s1,s1,0x1
    80006624:	8885                	andi	s1,s1,1
    80006626:	dd64                	sw	s1,124(a0)
    80006628:	bfe9                	j	80006602 <push_off+0x24>

000000008000662a <acquire>:
{
    8000662a:	1101                	addi	sp,sp,-32
    8000662c:	ec06                	sd	ra,24(sp)
    8000662e:	e822                	sd	s0,16(sp)
    80006630:	e426                	sd	s1,8(sp)
    80006632:	1000                	addi	s0,sp,32
    80006634:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006636:	00000097          	auipc	ra,0x0
    8000663a:	fa8080e7          	jalr	-88(ra) # 800065de <push_off>
  if(holding(lk))
    8000663e:	8526                	mv	a0,s1
    80006640:	00000097          	auipc	ra,0x0
    80006644:	f70080e7          	jalr	-144(ra) # 800065b0 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006648:	4705                	li	a4,1
  if(holding(lk))
    8000664a:	e115                	bnez	a0,8000666e <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000664c:	87ba                	mv	a5,a4
    8000664e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006652:	2781                	sext.w	a5,a5
    80006654:	ffe5                	bnez	a5,8000664c <acquire+0x22>
  __sync_synchronize();
    80006656:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000665a:	ffffa097          	auipc	ra,0xffffa
    8000665e:	7d0080e7          	jalr	2000(ra) # 80000e2a <mycpu>
    80006662:	e888                	sd	a0,16(s1)
}
    80006664:	60e2                	ld	ra,24(sp)
    80006666:	6442                	ld	s0,16(sp)
    80006668:	64a2                	ld	s1,8(sp)
    8000666a:	6105                	addi	sp,sp,32
    8000666c:	8082                	ret
    panic("acquire");
    8000666e:	00002517          	auipc	a0,0x2
    80006672:	1da50513          	addi	a0,a0,474 # 80008848 <digits+0x20>
    80006676:	00000097          	auipc	ra,0x0
    8000667a:	a7c080e7          	jalr	-1412(ra) # 800060f2 <panic>

000000008000667e <pop_off>:

void
pop_off(void)
{
    8000667e:	1141                	addi	sp,sp,-16
    80006680:	e406                	sd	ra,8(sp)
    80006682:	e022                	sd	s0,0(sp)
    80006684:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006686:	ffffa097          	auipc	ra,0xffffa
    8000668a:	7a4080e7          	jalr	1956(ra) # 80000e2a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000668e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006692:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006694:	e78d                	bnez	a5,800066be <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006696:	5d3c                	lw	a5,120(a0)
    80006698:	02f05b63          	blez	a5,800066ce <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000669c:	37fd                	addiw	a5,a5,-1
    8000669e:	0007871b          	sext.w	a4,a5
    800066a2:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800066a4:	eb09                	bnez	a4,800066b6 <pop_off+0x38>
    800066a6:	5d7c                	lw	a5,124(a0)
    800066a8:	c799                	beqz	a5,800066b6 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800066aa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800066ae:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800066b2:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800066b6:	60a2                	ld	ra,8(sp)
    800066b8:	6402                	ld	s0,0(sp)
    800066ba:	0141                	addi	sp,sp,16
    800066bc:	8082                	ret
    panic("pop_off - interruptible");
    800066be:	00002517          	auipc	a0,0x2
    800066c2:	19250513          	addi	a0,a0,402 # 80008850 <digits+0x28>
    800066c6:	00000097          	auipc	ra,0x0
    800066ca:	a2c080e7          	jalr	-1492(ra) # 800060f2 <panic>
    panic("pop_off");
    800066ce:	00002517          	auipc	a0,0x2
    800066d2:	19a50513          	addi	a0,a0,410 # 80008868 <digits+0x40>
    800066d6:	00000097          	auipc	ra,0x0
    800066da:	a1c080e7          	jalr	-1508(ra) # 800060f2 <panic>

00000000800066de <release>:
{
    800066de:	1101                	addi	sp,sp,-32
    800066e0:	ec06                	sd	ra,24(sp)
    800066e2:	e822                	sd	s0,16(sp)
    800066e4:	e426                	sd	s1,8(sp)
    800066e6:	1000                	addi	s0,sp,32
    800066e8:	84aa                	mv	s1,a0
  if(!holding(lk))
    800066ea:	00000097          	auipc	ra,0x0
    800066ee:	ec6080e7          	jalr	-314(ra) # 800065b0 <holding>
    800066f2:	c115                	beqz	a0,80006716 <release+0x38>
  lk->cpu = 0;
    800066f4:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800066f8:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800066fc:	0f50000f          	fence	iorw,ow
    80006700:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006704:	00000097          	auipc	ra,0x0
    80006708:	f7a080e7          	jalr	-134(ra) # 8000667e <pop_off>
}
    8000670c:	60e2                	ld	ra,24(sp)
    8000670e:	6442                	ld	s0,16(sp)
    80006710:	64a2                	ld	s1,8(sp)
    80006712:	6105                	addi	sp,sp,32
    80006714:	8082                	ret
    panic("release");
    80006716:	00002517          	auipc	a0,0x2
    8000671a:	15a50513          	addi	a0,a0,346 # 80008870 <digits+0x48>
    8000671e:	00000097          	auipc	ra,0x0
    80006722:	9d4080e7          	jalr	-1580(ra) # 800060f2 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
