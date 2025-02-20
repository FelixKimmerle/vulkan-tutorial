#pragma once
#define GLFW_INCLUDE_VULKAN
#include <GLFW/glfw3.h>

class Application
{
    public:
    void run();

    private:
    void init_window();
    void init_vulkan();
    void main_loop();
    void cleanup();
    void create_instance();
    void init_physical_dev();

    void setupDebugMessenger();

    GLFWwindow* window;
    VkInstance instance;
    VkDebugUtilsMessengerEXT debugMessenger;
    VkPhysicalDevice physicalDevice = VK_NULL_HANDLE;

};