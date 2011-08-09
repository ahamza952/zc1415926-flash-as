// SuperBible4_Chapter1.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include <gl\glut.h>

//Initialize square position and size
GLfloat x1 = 0.0f;
GLfloat y1 = 0.0f;
GLfloat rsize = 25;

//Step size in x and y directions
GLfloat xstep = 1.0f;
GLfloat ystep = 1.0f;

//Keep track of windows chaning width and height
GLfloat windowWidth;
GLfloat windowHeight;

void RenderScene(void)
{
	//Clear the window with current clearing color
	glClear(GL_COLOR_BUFFER_BIT);
	//Set current drawing color to red
	glColor3f(1.0f, 0.0f, 0.0f);
	//Draw a filled rectangle with current color
	glRectf(x1, y1, x1 + rsize, y1 - rsize);//左上角和右下角
 
	glutSwapBuffers();//做动画要开双缓存
}

void TimerFunction(int value)
{
	//Reverse direction when you reach left or right edge
	if(x1 + rsize > windowWidth || x1 < -windowWidth)
		xstep = -xstep;
	
	//Reverse direction when you reach top or bottom edge
	if(y1 > windowHeight || y1 -rsize < -windowHeight)
		ystep = -ystep;

	//Actually move the square
	x1 += xstep;
	y1 += ystep;

	/*Check bounds.This is in case the window is made
	smaller while the rectangle is bouncing and the 
	rectangle suddenly finds itselfoutside the new 
	cliping volume*/ 
	if(x1 + rsize > (windowWidth + xstep))//超出边界一步以上时
		x1 = windowWidth - rsize - 1;
	else if(x1 < -(windowWidth + xstep))
		x1 = -windowWidth - 1;

	if(y1 > (windowHeight + ystep))
		y1 = windowHeight - 1;
	else if(y1 < -(windowHeight - rsize + ystep))
		y1 = -windowHeight + rsize - 1;

	//Redraw the scene with new coordinates
	glutPostRedisplay();
	glutTimerFunc(33, TimerFunction, 1);

}
//Set up the rendering state
void SetupRC(void)
{
	glClearColor(0.0f, 0.0f, 1.0f, 1.0f);
}

void ChangeSize(GLsizei w, GLsizei h)
{
	GLfloat aspectRatio;
	
	//Prevent a divide by zero
	if(0 == h)
		h = 1;

	//Set Viewport to window dimensions
	glViewport(0, 0, w, h);

	//Reset coordinate system
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();

	//Establish clipping volume(left, right, bottom, top, near, far)
	aspectRatio = (GLfloat)w / (GLfloat)h;
	if(w <= h)
	{
		windowWidth = 100;
		windowHeight = 100 / aspectRatio;
		//glOrtho这把整个窗口的区域，最左边设成-100最右边设成100，依次类推
		glOrtho(-100.0, 100.0, -windowHeight, windowHeight, 1.0, -1.0);
	}
	else
	{
		windowWidth = 100 * aspectRatio;
		windowHeight = 100;
		glOrtho (-windowWidth, windowWidth, -100.0, 100.0, 1.0, -1.0);
    }	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
}

void main(int argc, char** argv)
{
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);
	glutInitWindowSize(800, 600);
	glutCreateWindow("Bounce");
	glutDisplayFunc(RenderScene);
	glutReshapeFunc(ChangeSize);
	glutTimerFunc(33, TimerFunction, 1);

	SetupRC();

	glutMainLoop();
}

