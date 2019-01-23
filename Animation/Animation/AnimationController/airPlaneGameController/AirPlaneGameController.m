//
//  AirPlaneGameController.m
//  Animation
//
//  Created by chenfeng on 2019/1/3.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "AirPlaneGameController.h"
#import <SceneKit/SceneKit.h>

typedef NS_ENUM(NSUInteger,MaskType) {
    MaskTypeWithEnemy = 1,
    MaskTypeWithBullet = 2,
    MaskTypeWithSphere = 4,
    MaskTypeWithShip = 8,
};

@interface AirPlaneGameController ()<SCNPhysicsContactDelegate>

@property (strong, nonatomic) SCNNode *sphereNode;
@property (strong, nonatomic) SCNNode *shipNode;
@property (strong, nonatomic) SCNView *scnView;
@property (assign, nonatomic) SCNVector3 vector;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation AirPlaneGameController


- (void)viewWillDisappear:(BOOL)animated
{
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //用于显示scene，具有监视场景节点，显示fps等作用
    _scnView = [[SCNView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    _scnView.allowsCameraControl = NO;
    
    // show statistics such as fps and timing information
    _scnView.showsStatistics = YES;
    [self.view addSubview:_scnView];
    
    //建立具体场景
    [self initScene];
    
    //生成敌人
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(generatingEnemies) userInfo:nil repeats:YES];
}

- (void)initScene{
    
    // create a new scene
    SCNScene *scene = [SCNScene sceneNamed:@"SceneKitSrc.scnassets/nor.scn"];
    
    // create and add a camera to the scene
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    [scene.rootNode addChildNode:cameraNode];
    
    // place the camera
    cameraNode.position = SCNVector3Make(0, 0, 30);//z坐标表示镜头的远近程度
    
    // set the scene to the view
    _scnView.scene = scene;
    //物理引擎关联代理
    _scnView.scene.physicsWorld.contactDelegate = self;
    
    //从场景获取实体
    _sphereNode = [_scnView.scene.rootNode childNodeWithName:@"sphere" recursively:YES];
    //节点的physicsBody默认为空，初始化后就会受重力，摩擦力等影响
    _sphereNode.physicsBody = [SCNPhysicsBody staticBody];
    //设置physicsBody的类别掩码，可以理解为一个身份标识，类似tag之类的
    _sphereNode.physicsBody.categoryBitMask = MaskTypeWithSphere;
    //设置physicsBody碰撞掩码，设置可以碰撞的物体
    _sphereNode.physicsBody.collisionBitMask = MaskTypeWithShip | MaskTypeWithEnemy;
    //设置physicsBody关系掩码，用于碰撞后在代理里面处理后续操作
    _sphereNode.physicsBody.contactTestBitMask = MaskTypeWithShip | MaskTypeWithEnemy;
    
    //获取飞船，创建scentkit demo的时候，有个飞船模型，直接拿来用了
    SCNScene *shipScene = [SCNScene sceneNamed:@"SceneKitSrc.scnassets/ship.scn"];
    
    _shipNode = [shipScene.rootNode childNodeWithName:@"ship" recursively:YES];
    _shipNode.physicsBody = [SCNPhysicsBody dynamicBody];
    //重力影响设置为NO
    _shipNode.physicsBody.affectedByGravity = NO;
    _shipNode.position = SCNVector3Make(0, -5, 0);
    
    _shipNode.physicsBody.categoryBitMask = MaskTypeWithShip;
    _shipNode.physicsBody.collisionBitMask = MaskTypeWithEnemy | MaskTypeWithSphere;
    _shipNode.physicsBody.contactTestBitMask = MaskTypeWithEnemy | MaskTypeWithSphere;
    [_scnView.scene.rootNode addChildNode:_shipNode];
    
    _vector = _shipNode.position;
    
    //绕y轴旋转动画,判断方式，用手握住坐标轴，大拇指指向坐标轴的方向，其余四指为旋转方向（至于顺逆时针，看坐标系而定）
    [_sphereNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:2]]];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touch began");
    //由于触摸点在视图空间为二维坐标，要转化成三维场景空间坐标，需要知道节点的深度，这里直接使用根节点的z坐标
    //意思就是，无论你点击哪里，深度都以根节点所在坐标为准
    SCNVector3 rootNodeVec = [_scnView projectPoint:_scnView.scene.rootNode.position];
    float projectedDepth = rootNodeVec.z;
    
    //再进行x，y轴上的坐标转换
    CGPoint point = [[touches anyObject] locationInView:_scnView];
    SCNVector3 vpWithDepth = SCNVector3Make(point.x, point.y, projectedDepth);
    SCNVector3 movePoint = [_scnView unprojectPoint:vpWithDepth];
    
    //飞船移动
    [self shipMoveWithPoint:movePoint];
    //飞船移动时左右偏转
    [self shipDeflectionWithPoint:movePoint];
    //飞船发射子弹
    [self bulletLaunch];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    SCNVector3 rootNodeVec = [_scnView projectPoint:_scnView.scene.rootNode.position];
    
    float projectedDepth = rootNodeVec.z;
    
    CGPoint point = [[touches anyObject] locationInView:_scnView];
    SCNVector3 vpWithDepth = SCNVector3Make(point.x, point.y, projectedDepth);
    SCNVector3 movePoint = [_scnView unprojectPoint:vpWithDepth];
    
    [self shipMoveWithPoint:movePoint];
    [self bulletLaunch];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touch ended");
    //由于飞船受各种力影响，所以在结束触摸时，移除飞船受到的力，不然会出现偏转
    [_shipNode.physicsBody clearAllForces];
}

- (void)shipMoveWithPoint:(SCNVector3)movePoint
{
    //飞船的飞行动画
    [_shipNode runAction:[SCNAction moveTo:movePoint duration:0.4]];
}

- (void)shipDeflectionWithPoint:(SCNVector3)movePoint
{
    //判断飞船向左还是向右运动
    if (movePoint.x > _vector.x) {
        
        SCNAction *action = [SCNAction customActionWithDuration:0.4 actionBlock:^(SCNNode * _Nonnull node, CGFloat elapsedTime) {
            //飞船偏转角度，elapsedTime是个递增参数
            node.eulerAngles = SCNVector3Make(0, 2 * elapsedTime, 0);
        }];
        //飞船执行偏转
        [_shipNode runAction:action completionHandler:^{
            //偏转完成后，复原
            [self->_shipNode runAction:[SCNAction rotateToAxisAngle:SCNVector4Make(0, 0, 0, 0) duration:0.4]];
        }];
        
        _vector = movePoint;
    }
    else if (movePoint.x < _vector.x)
    {
        SCNAction *action = [SCNAction customActionWithDuration:0.4 actionBlock:^(SCNNode * _Nonnull node, CGFloat elapsedTime) {
            node.eulerAngles = SCNVector3Make(0, -2 * elapsedTime, 0);
        }];
        
        [_shipNode runAction:action completionHandler:^{
            [self->_shipNode runAction:[SCNAction rotateToAxisAngle:SCNVector4Make(0, 0, 0, 0) duration:0.4]];
        }];
        
        _vector = movePoint;
    }
}


- (void)bulletLaunch
{
    //创建子弹对象
    SCNGeometry *sphere = [SCNSphere sphereWithRadius:0.2];
    sphere.firstMaterial.diffuse.contents = kOrangeColor;
    
    SCNNode *bullet = [SCNNode nodeWithGeometry:sphere];
    bullet.physicsBody = [SCNPhysicsBody dynamicBody];
    bullet.physicsBody.affectedByGravity = NO;
    bullet.position = SCNVector3Make(_shipNode.position.x, _shipNode.position.y, _shipNode.position.z);

    bullet.physicsBody.categoryBitMask = MaskTypeWithBullet;
    bullet.physicsBody.collisionBitMask = MaskTypeWithEnemy;
    bullet.physicsBody.contactTestBitMask = MaskTypeWithEnemy;
    
    [_scnView.scene.rootNode addChildNode:bullet];
    //子弹移动
    [bullet runAction:[SCNAction moveTo:SCNVector3Make(bullet.position.x, bullet.position.y + 30, bullet.position.z) duration:1] completionHandler:^{
        [bullet removeFromParentNode];
    }];
}

- (void)generatingEnemies
{
    //创建敌人
    CGFloat radius = (float)(arc4random()%100) / 100 + 0.3;
    
    CGFloat x = (float)(arc4random()%10) - 5;
    CGFloat y = (float)(arc4random()%20) + 15;
    
    SCNGeometry *sphere = [SCNSphere sphereWithRadius:radius];
    
    NSArray *contents = @[@"SceneKitSrc.scnassets/20190117-0.png",@"SceneKitSrc.scnassets/20190117-1.png",@"SceneKitSrc.scnassets/20190117-2.png",@"SceneKitSrc.scnassets/20190117-3.png",@"SceneKitSrc.scnassets/20190117-4.png"];
    
    sphere.firstMaterial.diffuse.contents = contents[arc4random()%5];
    
    SCNNode *enemy = [SCNNode nodeWithGeometry:sphere];
    enemy.position = SCNVector3Make(x, y, 0);
    enemy.physicsBody = [SCNPhysicsBody dynamicBody];
    //设置阻尼系数，系数越大，物体运动越缓慢
    enemy.physicsBody.damping = 0.5;
    
    enemy.physicsBody.categoryBitMask = MaskTypeWithEnemy;
    enemy.physicsBody.collisionBitMask = MaskTypeWithBullet | MaskTypeWithEnemy | MaskTypeWithShip | MaskTypeWithSphere;
    enemy.physicsBody.contactTestBitMask = MaskTypeWithBullet | MaskTypeWithEnemy | MaskTypeWithShip | MaskTypeWithSphere;
    
    [_scnView.scene.rootNode addChildNode:enemy];
}

#pragma mark SCNPhysicsContactDelegate

- (void)physicsWorld:(SCNPhysicsWorld *)world didBeginContact:(SCNPhysicsContact *)contact{
    //开始碰撞,得到两个碰撞的node
    SCNNode *nodeA = contact.nodeA;
    SCNNode *nodeB = contact.nodeB;
    
    //执行碰撞后的操作
    if((nodeA.physicsBody.categoryBitMask == MaskTypeWithEnemy &&
       nodeB.physicsBody.categoryBitMask == MaskTypeWithBullet) ||
       (nodeA.physicsBody.categoryBitMask == MaskTypeWithBullet &&
       nodeB.physicsBody.categoryBitMask == MaskTypeWithEnemy)){
        
        [nodeA removeFromParentNode];
        [nodeB removeFromParentNode];
    }
}

- (void)physicsWorld:(SCNPhysicsWorld *)world didUpdateContact:(SCNPhysicsContact *)contact{
    
}

- (void)physicsWorld:(SCNPhysicsWorld *)world didEndContact:(SCNPhysicsContact *)contact{
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
